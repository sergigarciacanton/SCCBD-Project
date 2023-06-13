import { Schema, model } from "mongoose";
const UserSchema = new Schema({
  name: { type: String, required: true },
  password: { type: String, required: true },
  type: { type: Number, required: true },
});
export default model("User", UserSchema);
