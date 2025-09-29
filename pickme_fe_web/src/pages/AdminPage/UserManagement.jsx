import { useState } from "react";
import { Search } from "@mui/icons-material";
import UserTable from "../../components/Admin/User/UserTable";
import { Box, InputAdornment, TextField, Typography } from "@mui/material";
import BackToDashboardButton from "../../components/Button/backToDashboardButton";

export default function UserManagementPage() {
  // State
  const [searchKeyword, setSearchKeyword] = useState("");
  const [roleFilter, setRoleFilter] = useState("");

  const roles = [
    { id: 1, name: "Admin", value: "ADMIN" },
    { id: 2, name: "Customer", value: "CUSTOMER" },
    { id: 3, name: "Restaurant owner", value: "RESTAURANT_OWNER" },
    { id: 4, name: "Tất cả", value: "" },
  ];

  return (
    <Box sx={{ p: 3 }}>
      <Box
        sx={{
          display: "flex",
          justifyContent: "space-between",
          alignItems: "center",
          mt: 1,
        }}
      >
        {/* Button back to dashboard */}
        <BackToDashboardButton />

        {/* Title */}
        <Typography variant="h5" fontWeight={700} px={4}>
          Danh sách người dùng
        </Typography>

        {/* Search & Filter */}
        <Box>
          {/* Search with name */}
          <TextField
            sx={{
              mr: 2,
              borderRadius: 2,
              "& .MuiOutlinedInput-root": {
                borderRadius: 2,
              },
            }}
            size="small"
            value={searchKeyword}
            onChange={(e) => {
              setSearchKeyword(e.target.value);
            }}
            placeholder="Tìm theo tên"
            InputProps={{
              startAdornment: (
                <InputAdornment position="start">
                  <Search />
                </InputAdornment>
              ),
            }}
          />

          {/* Filter with role */}
          <TextField
            select
            sx={{
              mr: 2,
              borderRadius: 2,
              "& .MuiOutlinedInput-root": {
                borderRadius: 2,
              },
            }}
            size="small"
            value={roleFilter}
            onChange={(e) => {
              setRoleFilter(e.target.value);
            }}
            SelectProps={{
              native: true,
            }}
          >
            {roles.map((role) => (
              <option key={role.id} value={role.value}>
                {role.name}
              </option>
            ))}
          </TextField>
        </Box>
      </Box>

      {/* User Table */}
      <UserTable searchKeyword={searchKeyword} roleFilter={roleFilter} />
    </Box>
  );
}
