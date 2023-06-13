import { Request, Response, Router } from "express"; //Import SOME modules from express.
import * as rsa from "rsa-module";

class RsaRoutes {
  public router: Router;
  public keys!: rsa.KeyPair;
  constructor() {
    this.router = Router();
    this.routes(); //This has to be written here so that the method can actually be configured when called externally.
  }

  private async init() {
    this.keys = await rsa.generateKeyPair(2048);
  }

  getAPIUsage = (req: Request, res: Response): void => {
    const message =
      "Usage:<br>Get server's public key: /<br>Sign a message: /sign/:message<br>Verify a ciphertext: /verify/:ciphertext<br>Encrypt a message: /encrypt/:message<br>Decrypt a ciphertext: /decrypt/:ciphertext";
    res.status(200).send(message);
  };

  getPubKey = (req: Request, res: Response): void => {
    res.status(200).json(this.keys.pubKey.toJSON());
  };

  sign = (req: Request<any, any, rsa.JsonMessage>, res: Response): void => {
    const message: bigint = rsa.JsonMessage.fromJSON(req.body);
    console.log("Message to sign: ", message);
    const signed: bigint = this.keys.privKey.sign(message);
    console.log("Signed message: ", signed);
    res.status(200).json(rsa.JsonMessage.toJSON(signed));
  };

  decrypt = (req: Request<any, any, rsa.JsonMessage>, res: Response): void => {
    const ciphertext: bigint = rsa.JsonMessage.fromJSON(req.body);
    console.log("Ciphertext to decrypt: ", ciphertext);
    const decrypted: bigint = this.keys.privKey.decrypt(ciphertext);
    console.log("Decrypted message: ", decrypted);
    res.status(200).json(rsa.JsonMessage.toJSON(decrypted));
  };

  verify = (req: Request<any, any, rsa.JsonMessage>, res: Response): void => {
    const ciphertext: bigint = rsa.JsonMessage.fromJSON(req.body);
    console.log("Ciphertext to verify: ", ciphertext);
    const verified: bigint = this.keys.pubKey.verify(ciphertext);
    console.log("Verified message: ", verified);
    res.status(200).json(rsa.JsonMessage.toJSON(verified));
  };

  encrypt = (req: Request<any, any, rsa.JsonMessage>, res: Response): void => {
    const message: bigint = rsa.JsonMessage.fromJSON(req.body);
    console.log("Message to encrypt: ", message);
    const encrypted: bigint = this.keys.pubKey.encrypt(message);
    console.log("Encrypted ciphertext: ", encrypted);
    res.status(200).json(rsa.JsonMessage.toJSON(encrypted));
  };

  async routes() {
    await this.init();
    this.router.get("/", this.getAPIUsage);
    this.router.get("/getPubKey", this.getPubKey);
    this.router.post("/encrypt", this.encrypt);
    this.router.post("/decrypt", this.decrypt);
    this.router.post("/sign", this.sign);
    this.router.post("/verify", this.verify);
  }

  async getRouter() {
    await this.routes();
    return this.router;
  }
}

const rsaRoutes = new RsaRoutes();
export default rsaRoutes.getRouter();
