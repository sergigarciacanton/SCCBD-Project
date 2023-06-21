import express, { Request, Response } from "express";
import bcrypt from "bcryptjs";
import User from "../models/User.js";
import jwt from "jsonwebtoken";

async function signUp(req: Request, res: Response) {
  try {
    const { name, password, type } = req.body;

    let encryptedPassword;
    const salt = await bcrypt.genSalt(10);
    encryptedPassword = await bcrypt.hash(password, salt);

    if (await User.findOne({ name: name })) {
      res
        .status(406)
        .send({ message: "There is already a user with the same username." });
      return;
    }

    const newUser = new User({
      name: name,
      password: encryptedPassword,
      type: type,
    });

    const SECRET = process.env.JWT_SECRET;
    console.log(SECRET);

    const savedUser = await newUser.save();

    const token = jwt.sign(
      { id: savedUser._id, name: savedUser.name, type: savedUser.type },
      SECRET!,
      {
        expiresIn: 86400, //24 hours
      }
    );

    res.status(201).send({ message: `User singed up`, token });
    return;
  } catch (e) {
    res.status(500).send({ message: `Server error: ${e}` });
  }
}

async function signIn(req: Request, res: Response) {
  try {
    const { name, password } = req.body;

    const user = await User.findOne({
      name: name,
    });
    if (!user) {
      res
        .status(404)
        .send({ message: `Username password combination does not exist` });
      return;
    }

    if (!(await bcrypt.compare(password as string, user.password as string))) {
      res
        .status(404)
        .send({ message: `Username password combination does not exist` });
      return;
    }

    const SECRET = process.env.JWT_SECRET;
    const token = jwt.sign(
      { id: user._id, name: user.name, type: user.type },
      SECRET!,
      {
        expiresIn: 86400, //24 hours
      }
    );

    res.status(200).send({ message: "singin", token });
  } catch (e) {
    res.status(500).send({ message: `Server error: ${e}` });
  }
}

async function verifyToken(req: Request, res: Response) {
  try {
    const token = req.body.token;
    if (!token) {
      res.status(403).send({ message: "Token not provided" });
      return;
    }
    if (!(typeof token === "string")) throw "Token not a string";

    const SECRET = process.env.JWT_SECRET;
    let decoded;
    try {
      decoded = jwt.verify(token!, SECRET!);
    } catch (e) {
      res.status(403).send({ message: "Invalid token" });
      return;
    }

    const user = await User.findOne({ _id: decoded!.id });
    if (!user) {
      res.status(403).send({ message: "User not authorized" });
      return;
    }

    res.status(200).send({ message: "User Logged in" });
  } catch (e) {
    res.status(500).send({ message: `Server error: ${e}` });
    return;
  }
}

let router = express.Router();

router.post("/signUp", signUp);
router.post("/signIn", signIn);
router.post("/verifyToken", verifyToken);

export default router;
