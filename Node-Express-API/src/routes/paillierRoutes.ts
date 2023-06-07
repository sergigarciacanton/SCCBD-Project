import { Request, Response, Router } from "express"; //Import SOME modules from express.
import * as paillier from "paillier-module";

class PaillierRoutes {
  public router: Router;
  public keys!: paillier.KeyPair;
  constructor() {
    this.router = Router();
    this.routes(); //This has to be written here so that the method can actually be configured when called externally.
  }

  private async init() {
    this.keys = await paillier.generateKeyPair(2048);
  }

  getAPIUsage = (req: Request, res: Response): void => {
    const message =
      "Usage:<br>Get server's public key: /<br>Encrypt a message: /encrypt/:message<br>Decrypt a ciphertext: /decrypt/:ciphertext";
    res.status(200).send(message);
  };

  getPubKey = (req: Request, res: Response): void => {
    res.status(200).json(this.keys.pubKey.toJSON());
  };

  decrypt = (
    req: Request<any, any, paillier.JsonMessage>,
    res: Response
  ): void => {
    const ciphertext: bigint = paillier.JsonMessage.fromJSON(req.body);
    console.log("Ciphertext to decrypt: ", ciphertext);
    const decrypted: bigint = this.keys.privKey.decrypt(ciphertext);
    console.log("Decrypted message: ", decrypted);
    res.status(200).json(paillier.JsonMessage.toJSON(decrypted));
  };

  encrypt = (
    req: Request<any, any, paillier.JsonMessage>,
    res: Response
  ): void => {
    const message: bigint = paillier.JsonMessage.fromJSON(req.body);
    console.log("Message to encrypt: ", message);
    const encrypted: bigint = this.keys.pubKey.encrypt(message);
    console.log("Encrypted ciphertext: ", encrypted);
    res.status(200).json(paillier.JsonMessage.toJSON(encrypted));
  };

  async routes() {
    await this.init();
    this.router.get("/", this.getAPIUsage);
    this.router.get("/getPubKey", this.getPubKey);
    this.router.post("/encrypt", this.encrypt);
    this.router.post("/decrypt", this.decrypt);
  }

  async getRouter() {
    await this.routes();
    return this.router;
  }
}

const paillierRoutes = new PaillierRoutes();
export default paillierRoutes.getRouter();
