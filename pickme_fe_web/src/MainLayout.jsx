import { Routes, Route } from "react-router-dom";
import Homepage from "./pages/HomePage/HomePage";
import LoginPage from "./pages/LoginPage/LoginPage";

export default function MainLayout() {
  return (
    <Routes>
      <Route path="/" element={<Homepage />}></Route>
      <Route path="login" element={<LoginPage />} />
    </Routes>
  );
}
