import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Order Card UI
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      // Card content
      child: Column(
        children: [
          // Header: Order type, status, date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Đồ ăn",
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
              // Status and date
              Row(
                children: [
                  //Order Status
                  Text(
                    "status",
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(width: 6),

                  //Order Date
                  Text(
                    "ngay",
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Order Details
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order image
              // ClipRRect(
              //   borderRadius: BorderRadius.circular(8),
              //   child: Image.network(order.image, width: 70, height: 70),
              // ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title with verified icon
                    Row(
                      children: [
                        //Order Title
                        Flexible(
                          child: Text(
                            "title",
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        const SizedBox(width: 4),

                        // Verified Icon
                        const Icon(
                          Icons.verified,
                          color: Colors.green,
                          size: 16,
                        ),
                      ],
                    ),

                    const SizedBox(height: 2),

                    //Order Address
                    Text(
                      "ddija chi",
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                        height: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 6),

                    // Price and quantity
                    Row(
                      children: [
                        //Order Price
                        Text(
                          "giaađ",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                        const SizedBox(width: 6),
                        //Order Quantity
                        Text(
                          "• soos luong phần",
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Action Buttons: Review & Reorder
          Row(
            children: [
              Expanded(
                // Review Button
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  // Review Text
                  child: const Text(
                    "Đánh giá",
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              // Reorder Button
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: const Text(
                    "Đặt lại",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
