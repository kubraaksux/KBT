import {
  useFetcher,
  useLoaderData,
  type ShouldRevalidateFunctionArgs,
} from "react-router";
import type { Route } from "./+types/route";
import type { Chat, User } from "~/types";
import { Textarea } from "~/components/ui/textarea";
import { useState } from "react";
import { Button } from "~/components/ui/button";

// /user/123
export async function loader({ params }: Route.LoaderArgs) {
  const { id } = params;
  console.log(process.env.BACKEND_URL);

  const res = await fetch(`${process.env.BACKEND_URL}/chats/${id}`);

  if (!res.ok) {
    throw new Error("Failed to fetch data");
  }

  const data = await res.json();

  return data;
}

export async function action({ request, params }: Route.ActionArgs) {
  const { id } = params;
  const formData = await request.formData();
  const query = formData.get("query");
  if (typeof query !== "string") {
    throw new Error("Content must be a string");
  }
  const response = await fetch(
    `${process.env.BACKEND_URL}/chats/${id}/answer`,
    {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ query }),
    }
  );
  if (!response.ok) {
    throw new Error("Failed to send message");
  }
  const result = await response.json();
  return result;
}

export default function UserPage() {
  const data = useLoaderData<Chat | null>();

  const [query, setQuery] = useState("");

  const sendMessageFetcher = useFetcher();

  const handleSendMessage = async () => {
    if (query.trim() === "") return;
    try {
      await sendMessageFetcher.submit({ query }, { method: "post" });
      setQuery("");
    } catch (error) {
      console.error("Failed to send message:", error);
    }
  };

  return data ? (
    <div className="flex flex-col items-center justify-center h-screen">
      <h1 className="text-2xl font-bold mb-4">Welcome to the Chat Page</h1>
      <p className="mb-4"> Chat ID: {data.id}</p>
      <p className="mb-4">
        Created At: {new Date(data.createDate).toLocaleString()}
      </p>
      <p className="mb-4">
        Updated At: {new Date(data.updateDate).toLocaleString()}
      </p>
      <h2 className="text-xl font-semibold mt-6">Messages:</h2>
      {data.messages && data.messages.length > 0 ? (
        <ul className="mt-4">
          {data.messages.map((message, index) => (
            <li key={index} className="mb-2 p-2 border rounded">
              <p className="font-semibold">{message.role}:</p>
              <p>{message.content}</p>
            </li>
          ))}
        </ul>
      ) : (
        <p className="mt-4">No messages found in this chat.</p>
      )}
      <Textarea
        className="max-w-xl"
        value={query}
        onChange={(e) => setQuery(e.target.value)}
      />
      <Button className="mt-4" onClick={handleSendMessage}>
        {sendMessageFetcher.state !== "idle" ? "Sending..." : "Send Message"}{" "}
        {/* Show loading state */}
      </Button>
    </div>
  ) : (
    <div className="flex flex-col items-center justify-center h-screen">
      <h1 className="text-2xl font-bold mb-4">404 Not Found</h1>
    </div>
  );
}
