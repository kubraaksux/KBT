import { useLoaderData, useNavigate } from "react-router";
import type { Route } from "./+types/route";
import type { Chat, User } from "~/types";

// /user/123
export async function loader({ params }: Route.LoaderArgs) {
  const { id } = params;
  console.log(process.env.BACKEND_URL);

  const res = await fetch(`${process.env.BACKEND_URL}/users/${id}`);

  if (!res.ok) {
    throw new Error("Failed to fetch user data");
  }

  const user = await res.json();

  const res2 = await fetch(`${process.env.BACKEND_URL}/users/${id}/chats`);

  if (!res2.ok) {
    throw new Error("Failed to fetch chats");
  }

  const chats = await res2.json();

  return { user, chats };
}

export default function UserPage() {
  const data = useLoaderData<{ user: User | null; chats: Chat[] | null }>();
  const navigate = useNavigate();

  return data ? (
    <div className="flex flex-col items-center justify-center h-screen">
      <h1 className="text-2xl font-bold mb-4">Welcome to the User Page</h1>
      <p className="mb-4">User ID: {data.user?.id}</p>
      <p className="mb-4">User Name: {data.user?.firstName}</p>
      <p className="mb-4">User Email: {data.user?.lastName}</p>
      <p className="mb-4">User Birth Date: {data.user?.birthDate.toString()}</p>
      <p className="mb-4">User Username: {data.user?.username}</p>
      <h2 className="text-xl font-semibold mt-6">Chats:</h2>
      {data.chats && data.chats.length > 0 ? (
        <ul className="mt-4">
          {data.chats.map((chat) => (
            <li
              key={chat.id}
              className="mb-2 p-2 border rounded cursor-pointer hover:bg-accent"
              onClick={() => navigate(`/chats/${chat.id}`)}
            >
              <p>Chat ID: {chat.id}</p>
              <p>Created At: {new Date(chat.createDate).toLocaleString()}</p>
              <p>Updated At: {new Date(chat.updateDate).toLocaleString()}</p>
            </li>
          ))}
        </ul>
      ) : (
        <p className="mt-4">No chats found for this user.</p>
      )}
    </div>
  ) : (
    <div className="flex flex-col items-center justify-center h-screen">
      <h1 className="text-2xl font-bold mb-4">404 Not Found</h1>
    </div>
  );
}
