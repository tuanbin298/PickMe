import "./utils/index.css";
import App from "./App.jsx";
import { StrictMode } from "react";
import { createRoot } from "react-dom/client";
import { ToastContainer } from "react-toastify";
import CustomCloseButton from "./utils/components/closeButton.jsx";

createRoot(document.getElementById("root")).render(
  <StrictMode>
    {/* Main routes */}
    <App />

    {/* Toast msg */}
    <ToastContainer
      position="top-right"
      autoClose={3000}
      hideProgressBar={false}
      newestOnTop
      closeOnClick
      rtl={false}
      pauseOnFocusLoss
      draggable
      pauseOnHover
      theme="light"
      closeButton={<CustomCloseButton />}
    />
  </StrictMode>
);
