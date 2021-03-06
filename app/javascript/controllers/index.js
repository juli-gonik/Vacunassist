// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller

import { Application } from "stimulus";
import { definitionsFromContext } from "stimulus/webpack-helpers";

const application = Application.start();
const context = require.context(".", true, /\.js$/);
application.load(definitionsFromContext(context));

import SearchFormController from "./search_form_controller.js";
application.register("search-form", SearchFormController);
