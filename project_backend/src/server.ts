import express from "express";
import morgan from "morgan";
import helmet from "helmet";
import compression from "compression";
import cors from "cors";
import mongoose from "mongoose";
import dotenv from "dotenv";

import indexRoutes from "./routes/indexRoutes";
import authRoutes from "./routes/auth";
import rsaRoutes from "./routes/rsaRoutes";
import userRoutes from "./routes/usersRoutes";
import eventRoutes from "./routes/eventRoutes";
import { VerifyToken, VerifyAdminToken } from "./middlewares/verifyToken.js";

class Server {
  public app: express.Application;

  //The contructor will be the first code that is executed when an instance of the class is declared.
  constructor() {
    this.app = express();
  }

  config() {
    //MongoDB
    const MONGO_URI = "mongodb://localhost/sccbd";
    mongoose.connect(MONGO_URI).then((db) => console.log("DB is connected"));

    //Settings
    dotenv.config({ path: ".env.secret" });
    this.app.set("port", 3000);

    //Middlewares
    this.app.use(morgan("dev")); //Allows to see by console the petitions that eventually arrive.
    this.app.use(express.json()); //So that Express parses JSON as the body structure, as it doens't by default.
    this.app.use(express.urlencoded({ extended: false }));
    this.app.use(helmet()); //Offers automatically security in front of some cracking attacks.
    this.app.use(compression()); //Allows to send the data back in a compressed format.
    this.app.use(cors()); //It automatically configures and leads with CORS issues and configurations.
  }

  async routes() {
    this.app.use(indexRoutes);
    this.app.use("/api/auth", authRoutes);
    this.app.use("/api/rsa", VerifyToken, await rsaRoutes);
    this.app.use("/api/user", VerifyToken, userRoutes);
    this.app.use("/api/event", VerifyToken, eventRoutes);
  }

  async start() {
    this.config();
    await this.routes();
    this.app.listen(this.app.get("port"), () => {
      console.log("Server listening on port", this.app.get("port"));
    });
  }
}

const server = new Server();
server.start();
