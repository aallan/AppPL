Application Preformance Library

1. Introduction

2. Requirements

3. Installation

Below are the steps on how to start using AppPrefLib.

3.1 Download

3.2 Add to Your Xcode Project

* Add the AppPrefLib library file named "libAppPrefLib.a" to your Xcode project.
   * Open your project in Xcode and from the Project menu select "Add to Project..."
   * Browse to where you extracted the SDK, choose "libAppPrefLib.a" and then in the next screen click "Add."

* Add the AppPrefLib header file to your Xcode project.
   * Open your project in Xcode and from the Project menu select "Add to Project..."
   * Browse to where you extracted the SDK, choose "WMPrefLib.h"  and then in the next screen click "Add."

* Add the CoreTelephony framework to your project if it is not already included.
   * AppPrefLib requires this framework to compile.
   * To add the framework, in the "Groups & Files" panel, and under "Targets," right click on your project's target and select "Get Info." Then, in the "General" tab, click the "+" button below the "Linked Libraries" list and select the CoreTelephony framework.

* Add to "Other Linker Flags" the value "-ObjC".
   * From the "Project" menu select "Edit Project Settings."
   * At the top of the "Build" tab select "All Configurations" in "Configurations" dropdown list, type "Other Linker Flags" in search box and set the value of the "Other Link Flags" to -ObjC.
   * Note: You may need to add the -ObjC flag in the Target as well as in the Project Settings.

* Now build the project with the Simulator as the Active SDK.
 
4. Using AppPrefLib

AppPrefLib can be
