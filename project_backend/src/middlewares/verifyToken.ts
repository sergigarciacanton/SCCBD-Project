import { NextFunction, Request, Response } from "express";
import jwt from "jsonwebtoken";
import User from "../models/User";

export const VerifyToken = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  try {
    if (!req.headers.authorization)
      return res.status(401).send({ message: "No authorized" });
    const token = req.headers.authorization;

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
  } catch (e) {
    res.status(500).send({ message: `Server error: ${e}` });
    return;
  }
  next();
};

export const VerifyAdminToken = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  try {
    if (!req.headers.authorization)
      return res.status(401).send({ message: "No authorized" });
    const token = req.headers.authorization;

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
      res.status(403).send({ message: "User not authorized" });
      return;
    }

    const user = await User.findOne({ _id: decoded!.id });
    if (!user) {
      res.status(403).send({ message: "User not authorized" });
      return;
    }

    const type: Array<String> = decoded.type;
    if (!type.includes("1")) {
      res.status(403).send({ message: "Role not authorized" });
      return;
    }
  } catch (e) {
    res.status(500).send({ message: `Server error: ${e}` });
    return;
  }
  next();
};
