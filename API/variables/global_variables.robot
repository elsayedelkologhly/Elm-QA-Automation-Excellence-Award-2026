# Global suite variables for parameter cascading
*** Variables ***
# Global authentication tokens (populated during Suite Setup)
${GLOBAL_TEMP_ACCESS_TOKEN}    ${EMPTY}    # Set by initial login
${GLOBAL_ACCESS_TOKEN}         ${EMPTY}    # Set by OTP verification
${GLOBAL_USER_ID}              ${EMPTY}    # Set by OTP verification
${GLOBAL_SESSION_COOKIE}       ${EMPTY}    # Set by OTP verification

# Global headers dictionary (populated during authentication)
&{GLOBAL_HEADERS}               # Populated with authentication headers after login

# Test-level variables for entity cascading
${CREATED_AUCTION_ID}          ${EMPTY}    # Set during auction creation
${CURRENT_AUCTION_NUMBER}      ${EMPTY}    # Set during auction workflow
${CURRENT_GROUP_ID}            ${EMPTY}    # Set during group operations

# Business flow variables
${CURRENT_USER_NAME}           ${EMPTY}    # Set from user response
${CURRENT_SESSION_ID}          ${EMPTY}    # Set for session management
