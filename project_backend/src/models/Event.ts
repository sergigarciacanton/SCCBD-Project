import { Schema, model } from "mongoose";

const EventSchema = new Schema({
  name: { type: String, required: true },
  date: { type: Date, required: true },
  admin: { type: Schema.Types.ObjectId, ref: "User", required: true },
  pubKeys: { type: [String] }, //base64
  numSpots: { type: Number, required: true },
});
export default model("Event", EventSchema);
