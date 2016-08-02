# HEF patient_report

## Installation

### Getting the project

Fork/clone this repository.

### Ruby version

This project was created using ruby 2.3.0. To get this version of ruby, see [RVM](https://rvm.io/).

If you are using RubyMine, ruby versions can be [specified](https://www.jetbrains.com/help/ruby/8.0/configuring-ruby-sdk.html).

### Dependencies

This project manages dependencies using [Bundler](http://bundler.io/).

To install dependencies this way, run the following:

```
cd patient_report
bundle install
```

## Running

From the root of `patient_report`, run the following command in your terminal:

```
ruby sample_reports.rb
```

This will hit the endpoint to retrieve the JSON.

There is also JSON stored locally for development purposes. If you'd like to run the sample script using the local object instead, run this:

```
ruby sample_reports.rb dev
```