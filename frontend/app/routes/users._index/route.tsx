import { useLoaderData, useNavigate } from "react-router";
import type { Route } from "./+types/route";
import type { User } from "~/types";

// /user/123
export async function loader({ params }: Route.LoaderArgs) {
  console.log(process.env.BACKEND_URL);

  const res = await fetch(`${process.env.BACKEND_URL}/users`);

  if (!res.ok) {
    throw new Error("Failed to fetch users");
  }

  const data = await res.json();

  return data;
}

export default function UserPage() {
  const data = useLoaderData<User[] | null>();

  const navigate = useNavigate();

  return data ? (
    <div className="flex flex-col items-center justify-center overflow-auto">
      <h1 className="text-2xl font-bold mb-4">Welcome to the User Page</h1>
      {data.map((user) => (
        <div
          key={user.id}
          className="mb-4 p-2 border rounded cursor-pointer hover:bg-accent"
          onClick={() => {
            navigate(`/users/${user.id}`);
          }}
        >
          <p className="mb-2">User ID: {user.id}</p>
          <p className="mb-2">
            User Name: {user.firstName} {user.lastName}
          </p>
          <p className="mb-2">
            User Birth Date: {new Date(user.birthDate).toLocaleDateString()}
          </p>
          <p className="mb-2">User Username: {user.username}</p>
        </div>
      ))}
    </div>
  ) : (
    <div className="flex flex-col items-center justify-center h-screen">
      <h1 className="text-2xl font-bold mb-4">404 Not Found</h1>
    </div>
  );
}
