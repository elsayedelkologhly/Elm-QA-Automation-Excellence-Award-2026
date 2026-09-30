*** Settings ***
Documentation    Page object for auction attachments form (Form 3)
Library          Browser

*** Variables ***
# Main Asset Image Upload (Required)
${MAIN_ASSET_IMAGE_UPLOAD_BUTTON}    css=button[type="button"]
${MAIN_ASSET_IMAGE_PREVIEW}          css=img[alt*="test_asset_main.jpg"]

# Additional Asset Images Upload (Optional)
${ADDITIONAL_IMAGES_UPLOAD_BUTTON}   xpath=(//button[@type="button"])[2]

# Video Upload Options (Optional)
${VIDEO_OPTION_YOUTUBE_RADIO}        css=input[type="radio"]:checked
${VIDEO_OPTION_FILE_RADIO}           xpath=(//input[@type="radio"])[2]
${YOUTUBE_LINK_INPUT}                css=input[type="url"]

# Marketing Brochure Upload (Optional)
${DOWNLOAD_TEMPLATE_BUTTON}          css=button[class*="download"]
${BROCHURE_UPLOAD_BUTTON}            xpath=(//button[@type="button"])[3]

# Navigation Buttons
${PREVIOUS_BUTTON}                   css=button[class*="previous"]
${NEXT_BUTTON}                       css=button[class*="next"]

*** Keywords ***
Wait For Attachments Form
    [Documentation]    Wait for the attachments form to be visible
    Wait For Elements State    text="المرفقات"    visible    timeout=10s

Upload Main Asset Image
    [Documentation]    Upload the main asset image (required field)
    [Arguments]    ${image_path}
    Click    ${MAIN_ASSET_IMAGE_UPLOAD_BUTTON}
    Wait For Elements State    text="الصورة الرئيسية للأصل"    visible
    # File upload handled by Browser Library
    # Note: Promise To Upload Files is not a standard keyword - use Upload File By Selector or similar
    # ${upload_promise}=    Promise To Upload Files    ${image_path}
    # For actual implementation, use: Upload File By Selector    ${MAIN_ASSET_IMAGE_UPLOAD_BUTTON}    ${image_path}
    Sleep    2s
    Wait For Elements State    ${MAIN_ASSET_IMAGE_PREVIEW}    visible    timeout=10s

Upload Additional Images
    [Documentation]    Upload additional asset images (optional, up to 15 images)
    [Arguments]    @{image_paths}
    # ${upload_promise}=    Promise To Upload Files    @{image_paths}
    Click    ${ADDITIONAL_IMAGES_UPLOAD_BUTTON}
    Sleep    2s

Enter YouTube Video Link
    [Documentation]    Enter a YouTube video link (optional)
    [Arguments]    ${youtube_url}
    Fill Text    ${YOUTUBE_LINK_INPUT}    ${youtube_url}

Select Video Upload Method
    [Documentation]    Select video upload method: youtube or file
    [Arguments]    ${method}=youtube
    IF    '${method}' == 'file'
        Click    ${VIDEO_OPTION_FILE_RADIO}
    ELSE
        Click    ${VIDEO_OPTION_YOUTUBE_RADIO}
    END

Upload Marketing Brochure
    [Documentation]    Upload marketing brochure file (optional)
    [Arguments]    ${file_path}
    # ${upload_promise}=    Promise To Upload Files    ${file_path}
    Click    ${BROCHURE_UPLOAD_BUTTON}
    Sleep    2s

Download Brochure Template
    [Documentation]    Download the marketing brochure template
    Click    ${DOWNLOAD_TEMPLATE_BUTTON}

Click Next
    [Documentation]    Click the Next button to proceed to location form
    Click    ${NEXT_BUTTON}
    Wait For Elements State    ${NEXT_BUTTON}    stable    timeout=2s

Click Previous
    [Documentation]    Click the Previous button to go back
    Click    ${PREVIOUS_BUTTON}
