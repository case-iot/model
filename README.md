CASE (Context-aware Software Ecosystem)
=======================================

Evaluation of application models
--------------------------------

Supplementary evaluation for the paper **Semantic Model of Variability and Capabilities of IoT Applications for Embedded Software Ecosystems**.

# Browsing the sample scenarios

To investigate the tested application models and scenarios, see the [spec](spec)
folder.

# Installation

1. Install the Eye reasoner
    - ([Windows](http://eulersharp.sourceforge.net/README.Windows), [OS X](http://eulersharp.sourceforge.net/README.MacOSX), [Linux](http://eulersharp.sourceforge.net/README.Linux))
    - requires the SWI Prolog
        - `brew tap homebrew/x11`
        - `brew install swi-prolog`
2. Install [Ruby](https://www.ruby-lang.org/en/) version 2.x.x
3. Run in inside a folder for this repository: `gem install bundler`
4. Run in inside a folder for this repository: `bundle install`

# Running the specs

To run the tests, simply execute `rspec` in the folder of this repository.

# Source code

This repository only contains the use case tests, for the source code and the unit
tests, see [https://github.com/case-iot/app_model](https://github.com/case-iot/app_model)
