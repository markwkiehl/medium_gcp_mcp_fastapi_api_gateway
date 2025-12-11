@echo off
echo %~n0%~x0   version 0.0.2
echo.

rem v0.0.0	initial release
rem v0.0.1	Revised batch file sequence from 4 through 8
rem v0.0.2	Added ERRORLEVEL to gcloud storage cp .env gs://%GCP_GS_BUCKET%

rem Created by Mechatronic Solutions LLC
rem Mark W Kiehl
rem
rem LICENSE: MIT


rem Batch files: https://steve-jansen.github.io/guides/windows-batch-scripting/
rem Batch files: https://tutorialreference.com/batch-scripting/batch-script-tutorial
rem Scripting Google CLI:  https://cloud.google.com/sdk/docs/scripting-gcloud

rem Verify that CLOUDSDK_PYTHON has already been set permanently for the user by gcp_part1.bat
IF NOT EXIST "%CLOUDSDK_PYTHON%" (
echo ERROR: CLOUDSDK_PYTHON path not found.  %CLOUDSDK_PYTHON%
echo Did you previously run gcp_part1.bat ?
EXIT /B
)


rem Make sure GOOGLE_APPLICATION_CREDENTIALS is not set so that Google ADC flow will work properly.
IF NOT "%GOOGLE_APPLICATION_CREDENTIALS%"=="" (
echo .
echo ERROR: GOOGLE_APPLICATION_CREDENTIALS has been set!
echo GOOGLE_APPLICATION_CREDENTIALS=%GOOGLE_APPLICATION_CREDENTIALS%
echo The environment variable GOOGLE_APPLICATION_CREDENTIALS must NOT be set in order to allow Google ADC to work properly.
echo Press RETURN to unset GOOGLE_APPLICATION_CREDENTIALS, CTRL-C to abort. 
pause
@echo on
SET GOOGLE_APPLICATION_CREDENTIALS=
CALL SETX GOOGLE_APPLICATION_CREDENTIALS ""
@echo off
echo Restart this file %~n0%~x0
EXIT /B
)



SETLOCAL

rem Define the working folder to Google Cloud CLI (gcloud) | Google Cloud SDK Shell
rem derived from the USERPROFILE environment variable.
rem This requires that the Google CLI/SKD has already been installed.
SET PATH_GCLOUD=%USERPROFILE%\AppData\Local\Google\Cloud SDK
IF NOT EXIST "%PATH_GCLOUD%\." (
	echo ERROR: PATH_GCLOUD path not found.  %PATH_GCLOUD%
	echo Did you install Google CLI / SKD? 
	EXIT /B
)
rem echo PATH_GCLOUD: %PATH_GCLOUD%

rem The current working directory for this script should be the same as the Python virtual environment for this project.
SET PATH_SCRIPT=%~dp0
rem echo PATH_SCRIPT: %PATH_SCRIPT%


echo.
echo PROJECT LOCAL VARIABLES:
echo.


rem import the GCP project constants from file gcp_constants.bat
if EXIST "gcp_constants.bat" (
  for /F "tokens=*" %%I in (gcp_constants.bat) do set %%I
) ELSE (
  echo ERROR: unable to find gcp_constants.bat
  EXIT /B
)


rem ----------------------------------------------------------------------
rem Show the project variables related to this task

rem set the Google Cloud Platform Project ID
echo GCP_PROJ_ID: %GCP_PROJ_ID%

rem Cloud Storage bucket
echo GCP_GS_BUCKET: %GCP_GS_BUCKET%

echo GCP_GS_BUCKET_LOCATION: %GCP_GS_BUCKET_LOCATION%

rem Show the bucket file contents
echo.
echo The existing bucket file contents before copy: 
@echo on
CALL gcloud storage ls gs://%GCP_GS_BUCKET%
@echo off


echo.
echo This batch file will copy the following files to the GCP bucket "gs://%GCP_GS_BUCKET%":
echo 1) .env
echo.
echo Press ENTER to continue, or CTRL-C to abort.
pause


rem Copy the local folder and all subfolders and files to the bucket.
rem gcloud storage cp -r LOCAL_FOLDER_PATH gs://BUCKET_NAME/DESTINATION_PATH
rem -r (or --recursive): This flag is used for recursive copies, meaning it copies directories and their contents.
echo.
echo.
echo You may use this command to see the contents of the bucket:  gcloud storage ls gs://%GCP_GS_BUCKET%
@echo on
CALL gcloud storage cp .env gs://%GCP_GS_BUCKET%
@echo off
IF %ERRORLEVEL% NEQ 0 (
	echo ERROR %ERRORLEVEL%: gcloud storage cp .env gs://%GCP_GS_BUCKET%
	EXIT /B
)

rem
rem This batch file terminates after the cp command and all commands after this are not executed. 

rem Show the bucket file contents
echo.
echo Bucket file contents after copy: 
@echo on
CALL gcloud storage ls gs://%GCP_GS_BUCKET%
@echo off


echo.
echo.
echo You may use this command to see the contents of the bucket:  gcloud storage ls gs://%GCP_GS_BUCKET%




ENDLOCAL

echo.
echo This batch file %~n0%~x0 has ended normally (no errors).  
echo You can repeat running this batch file if needed, but you won't need to unless you change the bucket via a prior step.
echo Next, execute the batch file "gcp_6_docker_build".
