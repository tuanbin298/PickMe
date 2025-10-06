import {
  Box,
  Button,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Paper,
  Typography,
} from "@mui/material";
import { useEffect, useState } from "react";

export default function RestaurantTable({ searchKeyword, statusFilter }) {
  const [restaurants, setRestaurants] = useState([]);

  // Demo data (sau này bạn sẽ gọi API)
  const mockData = [
    {
      id: 1,
      name: "Quán Ăn Ngon Hà Nội",
      owner: "Nguyễn Văn A",
      status: "PENDING",
      phone: "0912345678",
    },
    {
      id: 2,
      name: "Nhà hàng Sài Gòn",
      owner: "Trần Thị B",
      status: "APPROVED",
      phone: "0987654321",
    },
    {
      id: 3,
      name: "Ẩm thực Miền Trung",
      owner: "Phạm Văn C",
      status: "REJECTED",
      phone: "0901122334",
    },
  ];

  useEffect(() => {
    // Lọc dữ liệu theo từ khóa và trạng thái
    let filtered = mockData;

    if (searchKeyword) {
      filtered = filtered.filter((item) =>
        item.name.toLowerCase().includes(searchKeyword.toLowerCase())
      );
    }

    if (statusFilter) {
      filtered = filtered.filter((item) => item.status === statusFilter);
    }

    setRestaurants(filtered);
  }, [searchKeyword, statusFilter]);

  const handleApprove = (id) => {
    alert(`✅ Đã duyệt quán ăn ID: ${id}`);
  };

  const handleReject = (id) => {
    alert(`❌ Đã từ chối quán ăn ID: ${id}`);
  };

  const handleView = (id) => {
    alert(`📄 Xem hồ sơ quán ăn ID: ${id}`);
  };

  return (
    <TableContainer component={Paper} sx={{ mt: 3, borderRadius: 3 }}>
      <Table>
        <TableHead>
          <TableRow>
            <TableCell>ID</TableCell>
            <TableCell>Tên quán ăn</TableCell>
            <TableCell>Chủ sở hữu</TableCell>
            <TableCell>Số điện thoại</TableCell>
            <TableCell>Trạng thái</TableCell>
            <TableCell align="center">Hành động</TableCell>
          </TableRow>
        </TableHead>
        <TableBody>
          {restaurants.map((r) => (
            <TableRow key={r.id}>
              <TableCell>{r.id}</TableCell>
              <TableCell>{r.name}</TableCell>
              <TableCell>{r.owner}</TableCell>
              <TableCell>{r.phone}</TableCell>
              <TableCell>
                <Typography
                  sx={{
                    fontWeight: 600,
                    color:
                      r.status === "APPROVED"
                        ? "green"
                        : r.status === "REJECTED"
                        ? "red"
                        : "orange",
                  }}
                >
                  {r.status === "PENDING"
                    ? "Đang chờ duyệt"
                    : r.status === "APPROVED"
                    ? "Đã duyệt"
                    : "Bị từ chối"}
                </Typography>
              </TableCell>
              <TableCell align="center">
                <Box sx={{ display: "flex", gap: 1, justifyContent: "center" }}>
                  <Button
                    size="small"
                    variant="outlined"
                    color="info"
                    onClick={() => handleView(r.id)}
                  >
                    Xem hồ sơ
                  </Button>

                  {r.status === "PENDING" && (
                    <>
                      <Button
                        size="small"
                        variant="contained"
                        color="success"
                        onClick={() => handleApprove(r.id)}
                      >
                        Duyệt
                      </Button>
                      <Button
                        size="small"
                        variant="contained"
                        color="error"
                        onClick={() => handleReject(r.id)}
                      >
                        Từ chối
                      </Button>
                    </>
                  )}
                </Box>
              </TableCell>
            </TableRow>
          ))}

          {restaurants.length === 0 && (
            <TableRow>
              <TableCell colSpan={6} align="center">
                Không có dữ liệu phù hợp
              </TableCell>
            </TableRow>
          )}
        </TableBody>
      </Table>
    </TableContainer>
  );
}
