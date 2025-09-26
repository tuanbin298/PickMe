import { Routes, Route } from "react-router-dom";
import Homepage from "./pages/HomePage/HomePage";

export default function MainLayout() {
  return (
    <Routes>
      <Route path="/" element={<Homepage />}>
        {/* <Route path="login" element={<LoginPage />} /> */}
        {/* <Route path="register" element={<RegisterPage />} /> */}
      </Route>
    </Routes>
  );
}
