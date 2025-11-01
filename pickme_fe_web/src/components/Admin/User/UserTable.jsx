import { DataGrid } from "@mui/x-data-grid";
import { useEffect, useState } from "react";
import userService from "../../../../services/user/userService";
import { Chip } from "@mui/material";
import { formatDate, formatTime } from "../../../utils/formatDateTime";

export default function UserTable({ searchKeyword, roleFilter }) {
  const [usersData, setUsersData] = useState([]);

  // Object columns
  const columns = [
    { field: "id", headerName: "ID", width: 90 },
    { field: "fullName", headerName: "Họ tên", flex: 1 },
    { field: "email", headerName: "Email", flex: 1, sortable: false },
    {
      field: "role",
      headerName: "Vai trò",
      flex: 1,
      sortable: false,
      renderCell: (params) => {
        const roleColors = {
          ADMIN: "primary",
          CUSTOMER: "success",
          RESTAURANT_OWNER: "warning",
        };

        return (
          <Chip
            label={params.value}
            color={roleColors[params.value] || "default"}
            size="small"
          />
        );
      },
    },
    {
      field: "phoneNumber",
      headerName: "Số điện thoại",
      flex: 1,
      sortable: false,
    },
    {
      field: "isActive",
      headerName: "Trạng thái",
      flex: 1,
      sortable: false,
      renderCell: (params) => {
        const statusColors = {
          true: "success",
          false: "error",
        };

        const statusLabels = {
          true: "Đang hoạt động",
          false: "Ngưng",
        };

        return (
          <Chip
            label={statusLabels[params.value?.toString()]}
            color={statusColors[params.value?.toString()] || "default"}
            size="small"
          />
        );
      },
    },
    {
      field: "createdAt",
      headerName: "Thời gian tạo",
      flex: 1,
      sortable: false,
      renderCell: (params) => {
        const date = formatDate(params.value);
        const time = formatTime(params.value);

        return `${date} | ${time}`;
      },
    },
  ];

  useEffect(() => {
    const token = localStorage.getItem("sessionToken");

    // Fetch users from API
    const fetchUsers = async () => {
      try {
        const data = await userService.getAllUsers(token);
        setUsersData(data);
      } catch (error) {
        console.error("Lỗi tải người dùng:", error);
      }
    };

    fetchUsers();
  }, [searchKeyword, roleFilter]);

  // Filter and search
  const filteredUsers = usersData?.filter((user) => {
    // Match name
    const matchName = user.fullName
      .toLowerCase()
      .includes(searchKeyword.toLowerCase());

    // Match role
    const matchRole = roleFilter ? user.role === roleFilter : true;

    return matchName && matchRole;
  });

  return (
    <div style={{ height: 400, width: "100%" }}>
      {/* Table */}
      <DataGrid
        rows={filteredUsers}
        columns={columns}
        initialState={{
          pagination: { paginationModel: { pageSize: 5, page: 0 } },
        }}
        checkboxSelection
        pagination
      />
    </div>
  );
}
