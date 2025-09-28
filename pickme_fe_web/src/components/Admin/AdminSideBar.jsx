import {
  Box,
  Divider,
  Drawer,
  List,
  ListItem,
  ListItemButton,
  ListItemIcon,
  ListItemText,
  Toolbar,
} from "@mui/material";
import {
  Dashboard,
  ExitToApp,
  LocalOffer,
  People,
  Store,
} from "@mui/icons-material";
import { useState } from "react";
import { toast } from "react-toastify";
import { useNavigate } from "react-router-dom";
import images from "../../../constants/images";

const AdminSidebar = () => {
  // State
  const [active, setActive] = useState("dashboard");
  const navigate = useNavigate();

  const menuItems = [
    { id: "dashboard", label: "Dashboard", icon: <Dashboard /> },
    { id: "userlist", label: "Người dùng", icon: <People /> },
    { id: "restaurants", label: "Quán ăn", icon: <Store /> },
    { id: "promotions", label: "Khuyến mãi", icon: <LocalOffer /> },
  ];

  // Logout logic
  const handleLogout = () => {
    localStorage.removeItem("sessionToken");
    localStorage.removeItem("id");
    localStorage.removeItem("email");
    localStorage.removeItem("fullName");
    localStorage.removeItem("role");
    localStorage.removeItem("phoneNumber");
    localStorage.removeItem("imageUrl");

    toast.success("Đăng xuất thành công");

    navigate("/");
  };

  return (
    <Drawer
      variant="permanent"
      sx={{
        width: 240,
        flexShrink: 0,
        [`& .MuiDrawer-paper`]: {
          width: 240,
          boxSizing: "border-box",
        },
      }}
    >
      {/* Logo */}
      <Toolbar>
        <Box
          component="img"
          src={images.logo}
          alt="PickMe Logo"
          sx={{ height: 60, mx: "auto", width: 150, cursor: "pointer" }}
        />
      </Toolbar>

      <Divider sx={{ my: 2 }} />

      {/* Menu */}
      <List>
        {menuItems.map((item) => (
          <ListItem key={item.id} disablePadding>
            <ListItemButton
              selected={active === item.id}
              onClick={() => {
                setActive(item.id);
                navigate(`/dashboard/${item.id}`);
              }}
            >
              <ListItemIcon>{item.icon}</ListItemIcon>
              <ListItemText primary={item.label} />
            </ListItemButton>
          </ListItem>
        ))}
      </List>

      {/* Logout */}
      <ListItem disablePadding sx={{ mt: 2 }}>
        <ListItemButton onClick={handleLogout}>
          <ListItemIcon>
            <ExitToApp />
          </ListItemIcon>
          <ListItemText primary="Đăng xuất" />
        </ListItemButton>
      </ListItem>
    </Drawer>
  );
};

export default AdminSidebar;
