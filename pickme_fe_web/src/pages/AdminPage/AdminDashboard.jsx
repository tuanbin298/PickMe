import { Outlet } from "react-router-dom";
import AdminSidebar from "../../components/Admin/AdminSideBar";
import Header from "../../components/Header/Header";

const AdminDashboard = () => {
  return (
    <div
      style={{
        display: "flex",
        minHeight: "100vh",
        backgroundColor: "white",
      }}
    >
      {/* Side bar */}
      <AdminSidebar />

      <div style={{ flexGrow: 1, height: "100vh" }}>
        {/* Header */}
        <Header />
        <Outlet /> {/* Render child route */}
      </div>
    </div>
  );
};

export default AdminDashboard;
