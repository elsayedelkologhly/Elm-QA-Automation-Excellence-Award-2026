# API configuration from HAR file analysis
*** Variables ***
# Base configuration from HAR file
${BASE_URL}              https://mazad-ocelot.aks.thiqah.sa
${CAPTCHA_BASE_URL}      https://mazad-captcha.aks.thiqah.sa
${API_TIMEOUT}           30s
${SSL_VERIFY}            True

# Authentication configuration (based on HAR analysis)
${REQUIRES_AUTHENTICATION}    True
${LOGIN_ENDPOINT}        /web/emazad/Login/Login
${OTP_SEND_ENDPOINT}     /web/emazad/OTP/SendByTempAccessToken  
${OTP_VERIFY_ENDPOINT}   /web/emazad/login/VerifyOTP
${CAPTCHA_ENDPOINT}      /Captcha

# Token field names from HAR response analysis
${TEMP_TOKEN_FIELD}      tempAccessToken
${ACCESS_TOKEN_FIELD}    accessToken
${USER_ID_FIELD}         user.id

# Test credentials (based on HAR file data)
${USERNAME}              1174202257
${PASSWORD}              1234@Qwe
${TEST_CAPTCHA}          12345
${TEST_OTP}              11111

# API field mapping (from HAR request payloads)
${USERNAME_FIELD}        userNameOrEmailAddress
${PASSWORD_FIELD}        password
${CAPTCHA_FIELD}         captcha

# Default headers from HAR analysis
&{DEFAULT_HEADERS}        Content-Type=application/json    Accept=application/json
@{VALID_SUCCESS_STATUS}   200    201    202    204
@{CLIENT_ERROR_STATUS}    400    401    403    404    409
@{SERVER_ERROR_STATUS}    500    502    503    504

# API endpoint paths identified from HAR
${AUCTION_LIST_ENDPOINT}          /web/emazad/Auctions/GetPagedListAsync
${DRAFT_AUCTION_LIST_ENDPOINT}    /web/emazad/Auctions/GetDraftPagedListAsync
${CREATE_AUCTION_ENDPOINT}        /web/emazad/Auctions/CreateAuctionWithAssetAsync
${GET_DRAFT_AUCTION_ENDPOINT}     /web/emazad/Auctions/GetDraftForEditAsync

# Lookup/Reference Data APIs
${SALES_AGENT_DATA_ENDPOINT}      /web/emazad/SalesAgentRequest/GetSalesAgentDataAsync
${ASSET_TYPES_ENDPOINT}           /web/emazad/GlobalAssetType/GetSelectListAsync
${AUCTION_TYPES_ENDPOINT}         /web/emazad/Auctions/GetAuctionTypeSelectListAsync
${SUB_ASSET_TYPES_ENDPOINT}       /web/emazad/GlobalSubAssetType/GetSelectListAsync
${ASSET_PURPOSES_ENDPOINT}        /web/emazad/Assets/GetAssetPurposesSelectListAsync
${AUCTION_REGIONS_ENDPOINT}       /web/emazad/Auctions/GetAuctionRegionsSelectListAsync

# Financial/Calculation APIs
${PRICE_CALCULATION_ENDPOINT}     /web/emazad/AuctionCalculation/GetPricesAsync
