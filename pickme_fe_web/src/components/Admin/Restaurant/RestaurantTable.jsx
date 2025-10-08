import { DataGrid } from "@mui/x-data-grid";
import { useEffect, useState } from "react";
import {
  Chip,
  Box,
  Button,
  Modal,
  Paper,
  Typography,
  TextField,
  Divider,
  Stack,
} from "@mui/material";
import {
  CheckCircle,
  Close,
  Info,
  Block,
  Visibility,
  LocationOn,
} from "@mui/icons-material";
import { toast, ToastContainer } from "react-toastify";
import "react-toastify/dist/ReactToastify.css";
import restaurantService from "../../../../services/restaurant/restaurantService";

export default function RestaurantTable({ searchKeyword, statusFilter }) {
  const [restaurantsData, setRestaurantsData] = useState([]);
  const [selectedRestaurant, setSelectedRestaurant] = useState(null);
  const [openModal, setOpenModal] = useState(false);
  const [rejectReason, setRejectReason] = useState("");

  const token = localStorage.getItem("sessionToken");

  const fetchRestaurants = async () => {
    try {
      const data = await restaurantService.getAllRestaurants(token);
      setRestaurantsData(data);
    } catch (error) {
      console.error("Lỗi tải quán ăn:", error);
      setRestaurantsData([]);
      toast.error("Lỗi tải danh sách quán ăn");
    }
  };

  useEffect(() => {
    fetchRestaurants();
  }, []);

  const handleView = (restaurant) => {
    setSelectedRestaurant(restaurant);
    setOpenModal(true);
  };

  const handleCloseModal = () => {
    setOpenModal(false);
    setSelectedRestaurant(null);
    setRejectReason("");
  };

  const handleApprove = async (id) => {
    try {
      await restaurantService.approveRestaurant(id, token);
      toast.success("Duyệt quán thành công");
      fetchRestaurants();
      handleCloseModal();
    } catch (error) {
      toast.error("Lỗi khi duyệt quán");
      console.error(error);
    }
  };

  const handleReject = async (id) => {
    if (!rejectReason.trim()) {
      toast.warning("Vui lòng nhập lý do từ chối");
      return;
    }
    try {
      await restaurantService.rejectRestaurant(id, rejectReason, token);
      toast.success("Từ chối quán thành công");
      fetchRestaurants();
      handleCloseModal();
    } catch (error) {
      toast.error("Lỗi khi từ chối quán");
      console.error(error);
    }
  };

  const filteredRestaurants = restaurantsData.filter((r) => {
    const matchName = r.name
      .toLowerCase()
      .includes(searchKeyword.toLowerCase());
    const matchStatus = statusFilter ? r.approvalStatus === statusFilter : true;
    return matchName && matchStatus;
  });

  const columns = [
    { field: "id", headerName: "ID", width: 90 },
    { field: "name", headerName: "Tên quán ăn", flex: 1 },
    { field: "ownerName", headerName: "Chủ sở hữu", flex: 1 },
    { field: "phoneNumber", headerName: "Số điện thoại", flex: 1 },
    {
      field: "approvalStatus",
      headerName: "Trạng thái",
      flex: 1,
      renderCell: (params) => {
        const colors = {
          PENDING: "warning",
          APPROVED: "success",
          REJECTED: "error",
        };
        const labels = {
          PENDING: "Đang chờ duyệt",
          APPROVED: "Đã duyệt",
          REJECTED: "Bị từ chối",
        };
        return (
          <Chip
            label={labels[params.value]}
            color={colors[params.value]}
            size="small"
          />
        );
      },
    },
    {
      field: "actions",
      headerName: "Hành động",
      flex: 1.2,
      sortable: false,
      headerAlign: "center",
      renderCell: (params) => (
        <Box
          sx={{
            display: "flex",
            justifyContent: "center", // căn giữa ngang
            alignItems: "center", // căn giữa dọc
            width: "100%",
            height: "100%",
          }}
        >
          <Button
            size="small"
            variant="outlined"
            color="info"
            startIcon={<Visibility />}
            onClick={() => handleView(params.row)}
          >
            Xem
          </Button>
        </Box>
      ),
    },
  ];

  return (
    <>
      <ToastContainer position="top-right" autoClose={2000} />
      <Box sx={{ height: 520, width: "100%", mt: 2 }}>
        <DataGrid
          rows={filteredRestaurants}
          columns={columns}
          pageSizeOptions={[5, 10]}
          initialState={{
            pagination: { paginationModel: { pageSize: 5, page: 0 } },
          }}
        />
      </Box>

      {/* Modal chi tiết */}
      <Modal open={openModal} onClose={handleCloseModal}>
        <Paper
          elevation={6}
          sx={{
            position: "absolute",
            top: "50%",
            left: "50%",
            transform: "translate(-50%, -50%)",
            width: 500,
            maxHeight: "90vh",
            overflowY: "auto",
            p: 3,
            borderRadius: 3,
          }}
        >
          {selectedRestaurant && (
            <>
              <Typography variant="h6" fontWeight="bold" mb={2}>
                <Info sx={{ mr: 1, color: "primary.main" }} />
                Hồ sơ quán ăn
              </Typography>

              <Divider sx={{ mb: 2 }} />

              <Box>
                <Typography variant="subtitle1" fontWeight="bold">
                  {selectedRestaurant.name}
                </Typography>
                <Typography variant="body2" color="text.secondary">
                  {selectedRestaurant.address}
                </Typography>

                {/* 🗺️ Xem vị trí trên Google Maps */}
                <Stack direction="row" spacing={1} alignItems="center" mt={1}>
                  <LocationOn color="error" />
                  <Button
                    variant="text"
                    color="primary"
                    size="small"
                    sx={{ textTransform: "none", p: 0 }}
                    href={`https://www.google.com/maps?q=${selectedRestaurant.latitude},${selectedRestaurant.longitude}`}
                    target="_blank"
                    rel="noopener noreferrer"
                  >
                    Xem trên Google Maps
                  </Button>
                </Stack>

                <Stack spacing={0.5} mt={2}>
                  <Typography>
                    <strong>Chủ sở hữu:</strong> {selectedRestaurant.ownerName}
                  </Typography>
                  <Typography>
                    <strong>Số điện thoại:</strong>{" "}
                    {selectedRestaurant.phoneNumber}
                  </Typography>
                  <Typography>
                    <strong>Email:</strong> {selectedRestaurant.email}
                  </Typography>
                  <Typography>
                    <strong>Trạng thái:</strong>{" "}
                    <Chip
                      label={
                        selectedRestaurant.approvalStatus === "PENDING"
                          ? "Đang chờ duyệt"
                          : selectedRestaurant.approvalStatus === "APPROVED"
                          ? "Đã duyệt"
                          : "Bị từ chối"
                      }
                      color={
                        selectedRestaurant.approvalStatus === "APPROVED"
                          ? "success"
                          : selectedRestaurant.approvalStatus === "REJECTED"
                          ? "error"
                          : "warning"
                      }
                      size="small"
                      sx={{ ml: 1 }}
                    />
                  </Typography>
                </Stack>

                {selectedRestaurant.description && (
                  <Box mt={2}>
                    <Typography fontWeight="bold">Mô tả:</Typography>
                    <Typography variant="body2" sx={{ mt: 0.5 }}>
                      {selectedRestaurant.description}
                    </Typography>
                  </Box>
                )}

                {selectedRestaurant.imageUrl && (
                  <Box
                    component="img"
                    src={selectedRestaurant.imageUrl}
                    alt={selectedRestaurant.name}
                    sx={{
                      width: "100%",
                      mt: 2,
                      borderRadius: 2,
                      boxShadow: 1,
                      objectFit: "cover",
                    }}
                  />
                )}
              </Box>

              {/* Lý do từ chối + nút thao tác */}
              {selectedRestaurant.approvalStatus === "PENDING" && (
                <Box mt={3}>
                  <TextField
                    label="Nhập lý do từ chối"
                    fullWidth
                    multiline
                    rows={2}
                    value={rejectReason}
                    onChange={(e) => setRejectReason(e.target.value)}
                  />
                  <Stack
                    direction="row"
                    spacing={1.5}
                    justifyContent="flex-end"
                    mt={2}
                  >
                    <Button
                      variant="contained"
                      color="error"
                      onClick={() => handleReject(selectedRestaurant.id)}
                    >
                      Từ chối
                    </Button>
                    <Button
                      variant="contained"
                      color="success"
                      onClick={() => handleApprove(selectedRestaurant.id)}
                    >
                      Chấp nhận
                    </Button>
                    <Button variant="outlined" onClick={handleCloseModal}>
                      Hủy
                    </Button>
                  </Stack>
                </Box>
              )}

              {selectedRestaurant.approvalStatus !== "PENDING" && (
                <Box mt={3} textAlign="right">
                  <Button
                    variant="contained"
                    color="primary"
                    onClick={handleCloseModal}
                  >
                    Đóng
                  </Button>
                </Box>
              )}
            </>
          )}
        </Paper>
      </Modal>
    </>
  );
}
