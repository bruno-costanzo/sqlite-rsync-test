import { application } from "./application"

import FlashController from "./flash_controller"
application.register("flash", FlashController)

import ToggleClassController from "./toggle_class_controller"
application.register("toggle-class", ToggleClassController)
