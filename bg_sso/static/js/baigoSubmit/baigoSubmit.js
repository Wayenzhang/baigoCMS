/*
v1.1.2 jQuery baigoSubmit plugin 表单全选插件
(c) 2013 baigo studio - http://www.baigo.net/
License: http://www.opensource.org/licenses/mit-license.php
*/

(function($){
    $.fn.baigoSubmit = function(options) {
        "use strict";
        if(this.length < 1) {
            return this;
        }

        // support mutltiple elements
        if(this.length > 1){
            this.each(function(){
                $(this).baigoSubmit(options);
            });
            return this;
        }

        var thisForm = $(this); //定义表单对象
        var el = this;
        var _str_conn = "?";

        var defaults = {
            width: 350,
            height: 220,
            class_ok: "baigoSubmit_y",
            class_err: "baigoSubmit_x",
            class_submitting: "baigoSubmit_loading",
            text_submitting: "Submitting ...",
            btn_url: "",
            btn_text: "OK",
            btn_close: "Close",
            btn_submit: "",
            attach_key: ""
        };

        var opts = $.extend(defaults, options);

        //调用弹出框
        var callSuccModal = function(_image_pre, _class, _msg, _alert, _attach_value) {
            var obj_box = $("body .modal.baigoSubmit_box_succ");
            if (opts.btn_url.indexOf("?")) {
                _str_conn = "&";
            }
            var _html_box = "<div class=\"modal fade baigoSubmit_box_succ\"><div class=\"modal-dialog\"><div class=\"modal-content\"><div class=\"modal-body\">";
                _html_box += "<h4 class=\"box_msg " + _class + "\">" + _msg + "</h4>";
                _html_box += "<div class=\"box_alert\">" + _alert + "</div>";
            _html_box += "</div><div class=\"modal-footer\">";
                if (_image_pre == "y") {
                    if (opts.attach_key.length > 0 && typeof _attach_value != "undefined") {
                        _html_box += "<a href=\"" + opts.btn_url + _str_conn + opts.attach_key + "=" + _attach_value + "\" class=\"btn btn-primary btn_jump\" target=\"_top\">" + opts.btn_text + "</a>";
                    } else {
                        _html_box += "<a href=\"" + opts.btn_url + "\" class=\"btn btn-primary btn_jump\" target=\"_top\">" + opts.btn_text + "</a>";
                    }
                }
                _html_box += "<button type=\"button\" class=\"btn btn-default\" data-dismiss=\"modal\">" + opts.btn_close + "</button>";
            _html_box += "</div></div></div></div>";

            if (obj_box.length < 1) {
                $("body").append(_html_box);
            }

            $("body .modal.baigoSubmit_box_succ").modal("show");

            $("body .modal.baigoSubmit_box_succ").on("hidden.bs.modal", function() {
                $("body .modal.baigoSubmit_box_succ").remove();
            });
        };

        var callPreModal = function(_action) {
            var obj_box = $("body .modal.baigoSubmit_box_pre");
            var _html_box = "<div class=\"modal fade baigoSubmit_box_pre\"><div class=\"modal-dialog\"><div class=\"modal-content\"><div class=\"modal-body\">";
                _html_box += "<h4 class=\"box_msg " + opts.class_submitting + "\">" + opts.text_submitting + "</h4>";
            _html_box += "</div><div class=\"modal-footer\">";
                _html_box += "<button type=\"button\" class=\"btn btn-default\" data-dismiss=\"modal\">" + opts.btn_close + "</button>";
            _html_box += "</div></div></div></div>";

            if (obj_box.length < 1) {
                $("body").append(_html_box);
            }

            if (_action == "show") {
                $("body .modal.baigoSubmit_box_pre").modal("show");
            } else {
                $("body .modal.baigoSubmit_box_pre").modal("hide");
            }

            $("body .modal.baigoSubmit_box_pre").on("hidden.bs.modal", function() {
                $("body .modal.baigoSubmit_box_pre").remove();
            });
        };

        var _is_modal = true;
        var obj_box;

        if (typeof opts.msg_box != "undefined") {
            obj_box = $(opts.msg_box + " .baigoSubmit_box_mini");
            if (obj_box.length < 1) {
                $(opts.msg_box).append("<div class=\"baigoSubmit_box_mini\"></div>");
            }
            _is_modal = false;
        }

        //确认消息
        var formConfirm = function() {
            if (typeof opts.confirm_selector == "undefined") {
                return true;
            } else {
                var _form_action = $(opts.confirm_selector).val();
                if (_form_action == opts.confirm_val) {
                    if (confirm(opts.confirm_msg)) {
                        return true;
                    } else {
                        return false;
                    }
                } else {
                    return true;
                }
            }
        };

        //ajax提交
        el.formSubmit = function() {
            if (formConfirm()) {
                if (opts.ajax_url.indexOf("?")) {
                    _str_conn = "&";
                } else {
                    _str_conn = "?";
                }
                $.ajax({
                    url: opts.ajax_url + _str_conn + "a=" + Math.random(), //url
                    //async: false, //设置为同步
                    type: "post",
                    dataType: "json", //数据格式为json
                    data: $(thisForm).serialize(),
                    beforeSend: function(){
                        if (_is_modal) {
                            callPreModal("show"); //输出正在提交
                        } else {
                            $(opts.msg_box + " .baigoSubmit_box_mini").removeClass(opts.class_ok + " " + opts.class_err);
                            $(opts.msg_box + " .baigoSubmit_box_mini").addClass(opts.class_submitting);
                            $(opts.msg_box + " .baigoSubmit_box_mini").text(opts.text_submitting); //填充消息内容
                        }
                        $(opts.btn_submit).attr("disabled", true);

                    }, //输出消息
                    success: function(_result){ //读取返回结果
                        var _image_pre      = _result.alert.substr(0, 1);
                        var _attach_value   = _result[opts.attach_key];
                        var _class;
                        if (_image_pre == "x") {
                            _class = opts.class_err;
                        } else {
                            _class = opts.class_ok;
                        }
                        if (_is_modal) {
                            callPreModal("hide"); //关闭正在提交
                            callSuccModal(_image_pre, _class, _result.msg, _result.alert, _attach_value); //输出消息
                        } else {
                            $(opts.msg_box + " .baigoSubmit_box_mini").removeClass(opts.class_submitting + " " + opts.class_ok + " " + opts.class_err);
                            $(opts.msg_box + " .baigoSubmit_box_mini").addClass(_class);
                            $(opts.msg_box + " .baigoSubmit_box_mini").text(_result.msg);
                        }
                        $(opts.btn_submit).removeAttr("disabled");
                    }
                });
            }
        };

        return this;
    };

})(jQuery);