Application Preformance Library

1. Introduction

2. Requirements

3. Installation

Below are the steps on how to start using AppPerfLib.

3.1 Download

3.2 Add to Your Xcode Project

* Add the AppPerfLib library file named "libAppPerfLib.a" to your Xcode project.
   * Open your project in Xcode and from the Project menu select "Add to Project..."
   * Browse to where you extracted the SDK, choose "libAppPerfLib.a" and then in the next screen click "Add."

* Add the AppPerfLib header file to your Xcode project.
   * Open your project in Xcode and from the Project menu select "Add to Project..."
   * Browse to where you extracted the SDK, choose "WMPrefLib.h"  and then in the next screen click "Add."

* Add the CoreTelephony and SystemConfiguration frameworks to your project if it is not already included.
   * AppPerfLib requires this framework to compile.
   * To add a framework, in the "Groups & Files" panel, and under "Targets," right click on your project's target and select "Get Info." Then, in the "General" tab, click the "+" button below the "Linked Libraries" list and select the CoreTelephony framework. Do the same again for the SystemConfiguration.

* Add to "Other Linker Flags" the value "-ObjC" and "-all_load".
   * From the "Project" menu select "Edit Project Settings."
   * At the top of the "Build" tab select "All Configurations" in "Configurations" dropdown list, type "Other Linker Flags" in search box and set the value of the "Other Link Flags" to -ObjC. Do the same for the -all_load flag.
   * Note: You may need to add the -ObjC -all_load flags in the Target as well as in the Project Settings. Objective-C only generates one symbol per class. We must force the linker to load the members of the class too. This is what flag -ObjC does. We must also force inclusion of all our objects from our static library by adding the linker flag -all_load. If you skip these flags sooner or later you will run into the error of "unrecognized selector" or get other exceptions.

* Now build the project with the Simulator as the Active SDK.
 
4. Using AppPerfLib

AppPerfLib can be
