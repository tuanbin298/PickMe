import { Routes, Route, useLocation } from "react-router-dom";
import Homepage from "./pages/HomePage/HomePage";
import LoginPage from "./pages/LoginPage/LoginPage";
import AdminDashboard from "./pages/AdminPage/AdminDashboard";

export default function MainLayout() {
  const location = useLocation();

  // Check dashboard access
  const isDashboard = location.pathname.startsWith("/dashboard");

  return (
    <>
      {isDashboard ? (
        <Routes>
          <Route path="/dashboard" element={<AdminDashboard />}></Route>
        </Routes>
      ) : (
        <Routes>
          <Route path="/" element={<Homepage />} />
          <Route path="login" element={<LoginPage />} />
        </Routes>
      )}
    </>
  );
}
