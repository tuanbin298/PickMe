import { useState } from "react";
import { Search } from "@mui/icons-material";
import {
  Box,
  InputAdornment,
  TextField,
  Typography,
  Button,
} from "@mui/material";
import BackToDashboardButton from "../../components/Button/backToDashboardButton";
import RestaurantTable from "../../components/Admin/Restaurant/RestaurantTable";

export default function RestaurantManagementPage() {
  // State
  const [searchKeyword, setSearchKeyword] = useState("");
  const [statusFilter, setStatusFilter] = useState("");

  const statusOptions = [
    { id: 1, name: "Tất cả", value: "" },
    { id: 2, name: "Đang chờ duyệt", value: "PENDING" },
    { id: 3, name: "Đã duyệt", value: "APPROVED" },
    { id: 4, name: "Bị từ chối", value: "REJECTED" },
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
          Quản lý Quán ăn
        </Typography>

        {/* Search & Filter */}
        <Box>
          {/* Search with name */}
          <TextField
            sx={{
              mr: 2,
              borderRadius: 2,
              "& .MuiOutlinedInput-root": { borderRadius: 2 },
            }}
            size="small"
            value={searchKeyword}
            onChange={(e) => setSearchKeyword(e.target.value)}
            placeholder="Tìm theo tên quán ăn"
            InputProps={{
              startAdornment: (
                <InputAdornment position="start">
                  <Search />
                </InputAdornment>
              ),
            }}
          />

          {/* Filter by status */}
          <TextField
            select
            sx={{
              borderRadius: 2,
              "& .MuiOutlinedInput-root": { borderRadius: 2 },
            }}
            size="small"
            value={statusFilter}
            onChange={(e) => setStatusFilter(e.target.value)}
            SelectProps={{ native: true }}
          >
            {statusOptions.map((status) => (
              <option key={status.id} value={status.value}>
                {status.name}
              </option>
            ))}
          </TextField>
        </Box>
      </Box>

      {/* Restaurant Table */}
      <RestaurantTable
        searchKeyword={searchKeyword}
        statusFilter={statusFilter}
      />
    </Box>
  );
}
