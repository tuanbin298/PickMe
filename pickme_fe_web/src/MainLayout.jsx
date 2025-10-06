import { Routes, Route, useLocation } from "react-router-dom";
import Homepage from "./pages/HomePage/HomePage";
import LoginPage from "./pages/LoginPage/LoginPage";
import AdminDashboard from "./pages/AdminPage/AdminDashboard";
import UserManagementPage from "./pages/AdminPage/UserManagement";
import RestaurantManagementPage from "./pages/AdminPage/RestaurantManagement";

export default function MainLayout() {
  const location = useLocation();

  // Check dashboard access
  const isDashboard = location.pathname.startsWith("/dashboard");

  return (
    <>
      {isDashboard ? (
        <Routes>
          <Route path="/dashboard" element={<AdminDashboard />}>
            <Route path="userlist" element={<UserManagementPage />} />
            <Route path="restaurants" element={<RestaurantManagementPage />} />
          </Route>
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
