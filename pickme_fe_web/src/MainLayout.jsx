import { Routes, Route, useLocation, useNavigate } from "react-router-dom";
import { useEffect } from "react";
import { toast } from "react-toastify";
import { Navigate } from "react-router-dom";

function MainLayout() {
  return (
    <Routes>
      <Route path="/" element={<Layout />}>
        {/* <Route index element={<HomePage />} />
        <Route path="login" element={<LoginPage />} />
        <Route path="register" element={<RegisterPage />} /> */}
      </Route>
    </Routes>
  );
}
