import { useNavigate } from "react-router-dom";
import { Button } from "@mui/material";
import ArrowBackIcon from "@mui/icons-material/ArrowBack";

const BackToDashboardButton = () => {
  const navigate = useNavigate();

  const handleBackDashboard = () => {
    navigate("/dashboard");
  };

  return (
    <Button
      onClick={handleBackDashboard}
      startIcon={<ArrowBackIcon />}
      variant="outlined"
      sx={{ mb: 2, mt: 2 }}
    >
      Quay lại Dashboard
    </Button>
  );
};

export default BackToDashboardButton;
