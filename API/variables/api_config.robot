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
${TEST_CAPTCHA_TOKEN}    test-token-123

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

&{TEST_PAGINATION_PAYLOAD}    pageNumber=1

&{TEST_AUCTION_MAIN_INFO}
...    globalAssetTypeId=3
...    typeId=1
...    causeId=${None}
...    globalAssetTypeName=أخرى
...    typeName=مزاد الكتروني

&{TEST_AUCTION_ASSET_DETAILS}
...    assetName=Robot Framework Test Asset
...    description=Test asset created by automation

&{TEST_AUCTION_REALESTATE_DETAILS}
...    auctionRegionId=2
...    auctionCityId=227
...    district=Test District
...    googleMapUrl=${EMPTY}
...    auctionRegionName=Test Region
...    auctionCityName=Test City

&{TEST_AUCTION_TIMING}
...    startDate=20/10/2026
...    startTime=01:00:00
...    endDate=21/10/2026
...    endTime=02:00:00

&{TEST_AUCTION_FINANCIAL_INFO}
...    calculateVatMethod=1
...    estimatedPrice=1000
...    solvency=100
...    startBidPrice=500
...    minimumBidPrice=400

&{TEST_AUCTION_SALES_AGENT_DETAILS}
...    phoneNumber=541111113
...    whatsAppNumber=541111113

&{TEST_AUCTION_MASTER_IMAGE}
...    url=https://storage.googleapis.com/gcp-mazad-preprod/750b1b28-ee6c-4504-ad90-f8c499a49a01
...    fileId=750b1b28-ee6c-4504-ad90-f8c499a49a01
...    name=jpg - Copy (2).jpg
...    size=${18710}
@{TEST_AUCTION_ADDITIONAL_IMAGES}

&{TEST_AUCTION_ATTACHMENTS}
...    masterImage=${TEST_AUCTION_MASTER_IMAGE}
...    additionalImages=${TEST_AUCTION_ADDITIONAL_IMAGES}
...    brochure=${None}
...    assetVideoUrl=${EMPTY}
...    assetVideoFile=${None}

@{TEST_AUCTION_ADDITIONAL_DATA}
&{TEST_AUCTION_PAYLOAD}
...    mainInfo=${TEST_AUCTION_MAIN_INFO}
...    assetDetails=${TEST_AUCTION_ASSET_DETAILS}
...    realestateDetails=${TEST_AUCTION_REALESTATE_DETAILS}
...    attachments=${TEST_AUCTION_ATTACHMENTS}
...    timing=${TEST_AUCTION_TIMING}
...    financialInfo=${TEST_AUCTION_FINANCIAL_INFO}
...    salesAgentDetails=${TEST_AUCTION_SALES_AGENT_DETAILS}
...    additionalData=${TEST_AUCTION_ADDITIONAL_DATA}

&{HAR_AUCTION_REALESTATE_DETAILS}
...    auctionRegionId=2
...    auctionCityId=227
...    district=11
...    googleMapUrl=${EMPTY}
...    auctionRegionName=الجوف
...    auctionCityName=طبرجل

&{HAR_AUCTION_TIMING}
...    startDate=10/21/2026
...    startTime=01:00:00
...    endDate=10/27/2026
...    endTime=01:00:00

&{HAR_AUCTION_FINANCIAL_INFO}
...    calculateVatMethod=1
...    estimatedPrice=11
...    solvency=11
...    startBidPrice=11
...    minimumBidPrice=10

&{HAR_AUCTION_MASTER_IMAGE}
...    url=https://storage.googleapis.com/gcp-mazad-preprod/a98d39ed-d4da-40eb-884f-66793a886bb0
...    fileId=a98d39ed-d4da-40eb-884f-66793a886bb0
...    name=6760135001_58b1c5c5f0_b.jpg
...    size=${102614}

&{HAR_AUCTION_ATTACHMENTS}
...    masterImage=${HAR_AUCTION_MASTER_IMAGE}
...    additionalImages=${TEST_AUCTION_ADDITIONAL_IMAGES}
...    brochure=${None}
...    assetVideoUrl=${EMPTY}
...    assetVideoFile=${None}

&{HAR_AUCTION_PAYLOAD}
...    mainInfo=${TEST_AUCTION_MAIN_INFO}
...    assetDetails=${TEST_AUCTION_ASSET_DETAILS}
...    realestateDetails=${HAR_AUCTION_REALESTATE_DETAILS}
...    timing=${HAR_AUCTION_TIMING}
...    financialInfo=${HAR_AUCTION_FINANCIAL_INFO}
...    salesAgentDetails=${TEST_AUCTION_SALES_AGENT_DETAILS}
...    attachments=${HAR_AUCTION_ATTACHMENTS}
...    additionalData=${TEST_AUCTION_ADDITIONAL_DATA}

${TEST_PAGE_TAKE_COUNT}    10
${TEST_PAGE_SKIP_COUNT}    0
&{TEST_OFFSET_PAGINATION_PAYLOAD}
...    take=${TEST_PAGE_TAKE_COUNT}
...    skip=${TEST_PAGE_SKIP_COUNT}
...    filter=${EMPTY}
...    sortBy=${EMPTY}
...    ascending=${True}
