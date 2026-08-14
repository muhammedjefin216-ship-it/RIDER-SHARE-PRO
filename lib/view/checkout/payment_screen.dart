import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/common/back_title_bar.dart';
import '../../widgets/trip/step_indicator_bar.dart';
import '../../widgets/trip/inline_notice.dart';

class PaymentScreen extends StatefulWidget {
  final int selectedSeatsCount;
  final double seatPrice;

  const PaymentScreen({
    Key? key,
    this.selectedSeatsCount = 1,
    this.seatPrice = 100.0,
  }) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {

  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvcController = TextEditingController();
  final TextEditingController _countryController = TextEditingController(text: 'India');

  bool _saveInfo = false;

  double get seatTotal => widget.selectedSeatsCount * widget.seatPrice;
  double get platformFee => seatTotal * 0.05; 
  double get totalAmount => seatTotal + platformFee;

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvcController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding:  EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               BackTitleBar(accentWord: 'Pay', restOfTitle: ' securely'),
               SizedBox(height: 8),
               StepIndicatorBar(
                steps: [StepItem('Review'), StepItem('Payment')],
                currentIndex: 1,
              ),
               SizedBox(height: 16),
              _buildBannerCard(),
               SizedBox(height: 16),
              _buildLinkPayCard(),
               SizedBox(height: 20),
              _buildPaymentMethodSection(),
               SizedBox(height: 16),
              _buildSaveInfoCard(),
               SizedBox(height: 20),
              _buildPriceDetailsCard(),
               SizedBox(height: 16),
               InlineNotice(
                icon: Icons.info_outline,
                title: 'Cancellation Policy',
                message:
                    'Full refund if cancelled at least 24 hours before the ride starts. Platform fee is non-refundable.',
                backgroundColor: AppColors.lightInputBg,
                borderColor: AppColors.lightInputBg,
                iconColor: AppColors.primaryNavy,
                textColor: AppColors.textPrimary,
              ),
               SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }


  Widget _buildBannerCard() {
    return Container(
      width: double.infinity,
      height: 100,
      padding:  EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient:  LinearGradient(
          colors: [AppColors.primaryNavy, AppColors.heroNavy],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child:  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'Finalize your journey to Mumbai',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildLinkPayCard() {
    return Container(
      padding:  EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightInputBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding:  EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryNavy,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child:  Icon(Icons.flash_on, color: AppColors.white, size: 16),
                  ),
                   SizedBox(width: 8),
                   Text(
                    'Link',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
               Text(
                '1-CLICK',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryNavy,
                ),
              ),
            ],
          ),
           SizedBox(height: 8),
           Text(
            'Pay 3× faster with your saved details.',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
           SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor:  Color(0xFF101828),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child:  Text(
                'Pay with Link',
                style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Text(
          'Payment Method',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
         SizedBox(height: 12),
        Container(
          padding:  EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.infoBannerBg,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
               Text('Card number',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
               SizedBox(height: 6),
              Container(
                height: 48,
                padding:  EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _cardNumberController,
                        keyboardType: TextInputType.number,
                        decoration:  InputDecoration(
                          hintText: '1234 5678 9101 1121',
                          hintStyle: TextStyle(color: AppColors.hintText, fontSize: 13),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                     Icon(Icons.credit_card, color: AppColors.textSecondary, size: 20),
                  ],
                ),
              ),
               SizedBox(height: 12),

             
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Text('Expiry',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                         SizedBox(height: 6),
                        Container(
                          height: 48,
                          padding:  EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: TextField(
                            controller: _expiryController,
                            keyboardType: TextInputType.datetime,
                            decoration:  InputDecoration(
                              hintText: 'MM / YY',
                              hintStyle: TextStyle(color: AppColors.hintText, fontSize: 13),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                   SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Text('CVC',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                         SizedBox(height: 6),
                        Container(
                          height: 48,
                          padding:  EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _cvcController,
                                  keyboardType: TextInputType.number,
                                  obscureText: true,
                                  decoration:  InputDecoration(
                                    hintText: '123',
                                    hintStyle: TextStyle(color: AppColors.hintText, fontSize: 13),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                               Icon(Icons.help_outline, color: AppColors.textSecondary, size: 18),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
               SizedBox(height: 12),

             
               Text('Country',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
               SizedBox(height: 6),
              Container(
                height: 48,
                padding:  EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: TextField(
                  controller: _countryController,
                  decoration:  InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  Widget _buildSaveInfoCard() {
    return Container(
      padding:  EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.infoBannerBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
           Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Save my information',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              SizedBox(height: 2),
              Text(
                'For faster checkout next time',
                style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
              ),
            ],
          ),
          Switch(
            value: _saveInfo,
            onChanged: (val) {
              setState(() {
                _saveInfo = val;
              });
            },
            activeColor: AppColors.primaryNavy,
          ),
        ],
      ),
    );
  }


  Widget _buildPriceDetailsCard() {
    return Container(
      padding:  EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.infoBannerBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text(
            'Price Details',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
           SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${widget.selectedSeatsCount} seat price',
                style:  TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              Text(
                '₹${seatTotal.toInt()}',
                style:  TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
              ),
            ],
          ),
           SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Text('Platform fee', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
              Text(
                '₹${platformFee.toInt()}',
                style:  TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
              ),
            ],
          ),
           Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Text(
                'Total amount',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              Text(
                '₹${totalAmount.toInt()}',
                style:  TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primaryNavy),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding:  EdgeInsets.all(16),
      decoration:  BoxDecoration(color: AppColors.white),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                 
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryNavy,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     Icon(Icons.lock, color: AppColors.white, size: 16),
                     SizedBox(width: 8),
                    Text.rich(
                      TextSpan(
                        children: [
                           TextSpan(
                            text: 'Pay ',
                            style: TextStyle(
                              color: AppColors.oliveGold,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          TextSpan(
                            text: '₹${totalAmount.toInt()}',
                            style:  TextStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
             SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:  [
                Icon(Icons.shield_outlined, color: AppColors.textSecondary, size: 12),
                SizedBox(width: 4),
                Text(
                  'Your payment data is encrypted and secure',
                  style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}