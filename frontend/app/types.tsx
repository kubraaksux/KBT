export interface User {
  id: string; // UUID string (public ID)
  firstName: string;
  lastName: string;
  birthDate: Date;
  username: string;
  gender: "male" | "female" | "other";
}

export interface ChatMessage {
  role: "user" | "assistant" | "system";
  content: string;
}

export interface Chat {
  _id?: string; // MongoDB ObjectId as string
  id: string; // UUID for the chat
  userId: string; // UUID or ObjectId as string
  messages: ChatMessage[]; // Array of messages
  createDate: Date;
  updateDate: Date;
}
