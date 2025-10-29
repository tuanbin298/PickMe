import { Routes, Route, useLocation } from "react-router-dom";
import Homepage from "./pages/HomePage/HomePage";
import LoginPage from "./pages/LoginPage/LoginPage";
import UserManagementPage from "./pages/AdminPage/UserManagement";
import RestaurantManagementPage from "./pages/AdminPage/RestaurantManagement";
import AdminLayout from "./pages/AdminPage/AdminLayout";
import AdminDashboardPage from "./pages/AdminPage/AdminDashboard";

export default function MainLayout() {
  const location = useLocation();

  // Check dashboard access
  const isDashboard = location.pathname.startsWith("/dashboard");

  return (
    <>
      {isDashboard ? (
        <Routes>
          <Route path="/dashboard" element={<AdminLayout />}>
            <Route path="overview" element={<AdminDashboardPage />} />
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
