import express from "express";
import morgan from "morgan";
import helmet from "helmet";
import compression from "compression";
import cors from "cors";

import indexRoutes from "./routes/indexRoutes";
import rsaRoutes from "./routes/rsaRoutes";
import paillierRoutes from "./routes/paillierRoutes";

class Server {
  public app: express.Application;

  //The contructor will be the first code that is executed when an instance of the class is declared.
  constructor() {
    this.app = express();
  }

  config() {
    //Settings
    this.app.set("port", process.env.PORT || 3000);

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
    this.app.use("/api/rsa", await rsaRoutes);
    this.app.use("/api/paillier", await paillierRoutes);
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
