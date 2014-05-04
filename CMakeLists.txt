
#-----------------------------------------------------------------------
# CPM configuration
#-----------------------------------------------------------------------
set(CPM_MODULE_NAME iauns_cpm_libovr)
set(CPM_LIB_TARGET_NAME ${CPM_MODULE_NAME})

if ((DEFINED CPM_DIR) AND (DEFINED CPM_UNIQUE_ID) AND (DEFINED CPM_TARGET_NAME))
  set(CPM_LIB_TARGET_NAME ${CPM_TARGET_NAME})
  set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CPM_DIR})
  include(CPM)
else()
  set(CPM_DIR "${CMAKE_CURRENT_BINARY_DIR}/cpm-packages" CACHE TYPE STRING)
  find_package(Git)
  if(NOT GIT_FOUND)
    message(FATAL_ERROR "CPM requires Git.")
  endif()
  if (NOT EXISTS ${CPM_DIR}/CPM.cmake)
    execute_process(
      COMMAND "${GIT_EXECUTABLE}" clone https://github.com/iauns/cpm ${CPM_DIR}
      RESULT_VARIABLE error_code
      OUTPUT_VARIABLE head_sha)
    if(error_code)
      message(FATAL_ERROR "CPM failed to get the hash for HEAD")
    endif()
  endif()
  include(${CPM_DIR}/CPM.cmake)
endif()

# All externals *must* define this.
CPM_ForceOnlyOneModuleVersion()

CPM_InitModule(${CPM_MODULE_NAME})

#------------------------------------------------------------------------------
# Oculus
#------------------------------------------------------------------------------

# We use the origin/master tag because there are no tags to use in the Tny repo.
set(REPO_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/3rdParty/OculusSDK")
CPM_EnsureRepoIsCurrent(
  TARGET_DIR ${REPO_SOURCE_DIR}
  GIT_REPOSITORY "https://github.com/jherico/OculusSDK.git"
  GIT_TAG "edf1c772a4a344354cc4813ecbbc97d129b7e24a"
  USE_CACHING TRUE
  )

add_subdirectory(${REPO_SOURCE_DIR}/LibOVR)

CPM_ExportAdditionalIncludeDir("${REPO_SOURCE_DIR}/LibOVR/Include")
CPM_ExportAdditionalLibraryTarget("OculusVR")

