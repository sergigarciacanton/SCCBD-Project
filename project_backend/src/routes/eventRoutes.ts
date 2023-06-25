import express, { Request, Response } from "express";

import Event from "../models/Event";
import User from "../models/User";
import * as rsa from "rsa-module";
import * as bc from "bigint-conversion";
import * as objectSha from "object-sha";
import { TextEncoder } from "util";

async function getEvents(req: Request, res: Response): Promise<void> {
  const allEvents = await Event.find().populate("admin", "name");
  if (allEvents.length == 0) {
    res.status(404).send("There are no events yet!");
  } else {
    let output = [{}];
    allEvents.forEach((element) => {
      const object = {
        _id: element._id,
        name: element.name,
        date: element.date,
        admin: element.admin,
        numSpots: element.numSpots,
        availableSpots: element.numSpots - element.pubKeys.length,
      };
      output.push(object);
    });
    res.status(200).send(output.splice(1, output.length - 1));
  }
}

async function getEventByName(req: Request, res: Response): Promise<void> {
  const eventFound = await Event.findOne({
    name: req.params.name,
  }).populate("admin", "name");
  if (eventFound == null) {
    res.status(404).send("The event doesn't exist!");
  } else {
    res.status(200).send({
      _id: eventFound._id,
      name: eventFound.name,
      date: eventFound.date,
      admin: eventFound.admin,
      numSpots: eventFound.numSpots,
      availableSpots: eventFound.numSpots - eventFound.pubKeys.length,
    });
  }
}

async function getEventsByAdminName(
  req: Request,
  res: Response
): Promise<void> {
  const user = await User.findOne({ name: req.params.name });
  const eventFound = await Event.find({
    admin: user,
  }).populate("admin", "name");
  if (eventFound == null) {
    res.status(404).send("The event doesn't exist!");
  } else if (eventFound.length == 0) {
    res.status(404).send("This user is not admin of any event!");
  } else {
    let output = [{}];
    eventFound.forEach((element) => {
      const object = {
        _id: element._id,
        name: element.name,
        date: element.date,
        admin: element.admin,
        numSpots: element.numSpots,
        availableSpots: element.numSpots - element.pubKeys.length,
      };
      output.push(object);
    });
    res.status(200).send(output.splice(1, output.length - 1));
  }
}

async function addEvent(req: Request, res: Response): Promise<void> {
  const { nameUser, name, date, numSpots } = req.body;
  const userFound = await User.findOne({
    name: nameUser,
  });
  const newEvent = new Event({
    name: name,
    date: date,
    admin: userFound,
    pubKeys: [],
    numSpots: numSpots,
  });
  await newEvent.save();
  res.status(200).send("Event added!");
}

async function joinEvent(req: Request, res: Response): Promise<void> {
  try {
    const { eventName } = req.params;
    const { pubKeys } = req.body;
    const event = await Event.findOne({ name: eventName });
    if (event == null) {
      res.status(404).send({ message: "Error. Event not found." });
      return;
    }
    Event.findOneAndUpdate(
      { name: eventName },
      { $push: { pubKeys: pubKeys } },
      function (error) {
        if (error) {
          res.status(500).send({ message: "Error adding the user to event." });
          return;
        }
      }
    );
    res.status(200).send({ message: "You joined the event!" });
  } catch (e) {
    res.status(500).send({ message: `Server error: ${e}` });
  }
}

async function leaveEvent(req: Request, res: Response): Promise<void> {
  try {
    const { eventName } = req.params;
    const { pubKey, signature } = req.body;
    const clientPubKey = rsa.RsaPubKey.fromJSON(pubKey);
    const verified = clientPubKey.verify(rsa.JsonMessage.fromJSON(signature));
    const digest = await objectSha.digest(
      bc.textToBuf(JSON.stringify(clientPubKey.toJSON())),
      "SHA-256"
    );
    console.log(bc.bigintToText(verified));
    //if (bc.bigintToText(verified) == digest) {
    const event = await Event.findOne({ name: eventName });
    if (event == null) {
      res.status(404).send({ message: "Error. Event not found." });
      return;
    }
    Event.findOneAndUpdate(
      { name: eventName },
      { $pull: { pubKeys: bc.bigintToText(verified) } },
      { new: true },
      function (error, affected) {
        console.log(event);
        console.log(affected);
        if (error) {
          console.log(error);
          res
            .status(500)
            .send({ message: "Error deleting the user to event." });
          return;
        } else if (event.pubKeys.length == affected!.pubKeys.length) {
          res.status(404).send({
            message: "User not present in event",
          });
          return;
        } else {
          res.status(200).send({
            message: "You left the event",
          });
        }
      }
    );
    /* } else {
      res.status(403).send({ message: `Bad auth` });
    } */
  } catch (e) {
    res.status(500).send({ message: `Server error: ${e}` });
  }
}

async function leaseEvent(req: Request, res: Response): Promise<void> {
  try {
    const { eventName } = req.params;
    const { pubKey, signature, fooPubKey } = req.body;
    const clientPubKey = rsa.RsaPubKey.fromJSON(pubKey);
    const verified = clientPubKey.verify(rsa.JsonMessage.fromJSON(signature));
    const digest = await objectSha.digest(
      JSON.stringify(clientPubKey.toJSON())
    );
    if (bc.bigintToText(verified) == digest) {
      const event = await Event.findOne({ name: eventName });
      if (event == null) {
        res.status(404).send({ message: "Error. Event not found." });
        return;
      }
      Event.findOneAndUpdate(
        { name: eventName },
        { $pull: { pubKeys: digest } },
        { new: true },
        function (error, affected) {
          if (error) {
            console.log(error);
            res
              .status(500)
              .send({ message: "Error deleting user from event." });
            return;
          } else if (event.pubKeys.length == affected!.pubKeys.length) {
            res.status(404).send({
              message: "User not present in event",
            });
            return;
          }
        }
      );
      Event.findOneAndUpdate(
        { name: eventName },
        { $push: { pubKeys: fooPubKey } },
        function (error) {
          if (error) {
            console.log(error);
            res.status(500).send({ message: "Error adding user to event." });
            return;
          } else {
            res.status(200).send({
              message: "Ticket leased successfully!",
            });
          }
        }
      );
    } else {
      res.status(403).send({ message: `Bad auth` });
    }
  } catch (e) {
    res.status(500).send({ message: `Server error: ${e}` });
  }
}

async function updateEvent(req: Request, res: Response): Promise<void> {
  const eventToUpdate = await Event.findOneAndUpdate(
    { name: req.params.nameEvent },
    req.body
  );
  if (eventToUpdate == null) {
    res.status(404).send("The event doesn't exist!");
  } else {
    res.status(200).send("Updated!");
  }
}

async function deleteEvent(req: Request, res: Response): Promise<void> {
  const eventToDelete = await Event.findOneAndDelete(
    { name: req.params.nameEvent },
    req.body
  );
  if (eventToDelete == null) {
    res.status(404).send("The event doesn't exist!");
  } else {
    res.status(200).send("Deleted!");
  }
}

let router = express.Router();

router.get("/", getEvents);
router.get("/:name", getEventByName);
router.get("/admin/:name", getEventsByAdminName);
router.post("/", addEvent);
router.put("/join/:eventName", joinEvent);
router.put("/leave/:eventName", leaveEvent);
router.put("/lease/:eventName", leaseEvent);
router.put("/:nameEvent", updateEvent);
router.delete("/:nameEvent", deleteEvent);

export default router;
