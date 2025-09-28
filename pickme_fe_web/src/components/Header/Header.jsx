import { Notifications, Search } from "@mui/icons-material";
import {
  AppBar,
  Toolbar,
  IconButton,
  InputBase,
  Box,
  Avatar,
  Typography,
} from "@mui/material";

const Header = () => {
  const avatarUrl = localStorage.getItem("imageUrl");
  const userName = localStorage.getItem("fullName");

  return (
    <AppBar
      position="static"
      sx={{
        zIndex: (theme) => theme.zIndex.drawer + 1,
        backgroundColor: "white",
        color: "black",
        boxShadow: "none",
        borderBottom: "1px solid #e0e0e0",
      }}
    >
      <Toolbar sx={{ display: "flex", justifyContent: "space-between" }}>
        {/* Welcome Text */}
        <Box>
          <Typography variant="h6" fontWeight="bold">
            Xin chào {userName || "Quản trị viên"}
          </Typography>
          <Typography variant="body2" color="text.secondary">
            Chào mừng bạn đến với trang quản trị
          </Typography>
        </Box>

        {/* Search box */}
        <Box
          sx={{
            display: "flex",
            alignItems: "center",
            px: 2,
            py: 0.5,
            borderRadius: 2,
            backgroundColor: "#f5f5f5",
            width: 300,
          }}
        >
          <Search sx={{ mr: 1, color: "gray" }} />
          <InputBase placeholder="Tìm kiếm quán ăn" fullWidth />
        </Box>

        {/* Right side */}
        <Box sx={{ display: "flex", alignItems: "center", gap: 2 }}>
          <IconButton>
            <Notifications />
          </IconButton>
          <Avatar src={avatarUrl} alt="User Avatar" />
        </Box>
      </Toolbar>
    </AppBar>
  );
};

export default Header;
