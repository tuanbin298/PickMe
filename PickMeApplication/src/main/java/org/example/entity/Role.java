package org.example.entity;

public enum Role {
    ADMIN,              // Quản trị hệ thống - duyệt restaurant, quản lý campaigns
    CUSTOMER,           // Khách hàng
    RESTAURANT_OWNER,   // Chủ quán - có thể có nhiều chi nhánh
    RESTAURANT_STAFF    // Nhân viên quán - chỉ quản lý 1 chi nhánh cụ thể
}