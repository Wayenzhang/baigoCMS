<?php
/*-----------------------------------------------------------------
！！！！警告！！！！
以下为系统文件，请勿修改
-----------------------------------------------------------------*/

//不能非法包含或直接执行
if(!defined("IN_BAIGO")) {
    exit("Access Denied");
}

include_once(BG_PATH_CLASS . "tpl.class.php");

/*-------------管理员控制器-------------*/
class CONTROL_OPT {

    private $adminLogged;
    private $obj_base;
    private $config; //配置
    private $obj_tpl;
    private $tplData;

    function __construct() { //构造函数
        $this->obj_base       = $GLOBALS["obj_base"];
        $this->config         = $this->obj_base->config;
        $this->adminLogged    = $GLOBALS["adminLogged"]; //获取已登录信息
        $this->obj_dir        = new CLASS_DIR(); //初始化目录对象
        $_arr_cfg["admin"] = true;
        $this->obj_tpl        = new CLASS_TPL(BG_PATH_TPLSYS . "admin/" . $this->config["ui"], $_arr_cfg); //初始化视图对象
        $this->tplData = array(
            "adminLogged" => $this->adminLogged
        );
    }


    function ctl_dbconfig() {
        if (!isset($this->adminLogged["groupRow"]["group_allow"]["opt"]["dbconfig"])) {
            return array(
                "alert" => "x060306",
            );
        }

        $this->tplData["act_get"] = $GLOBALS["act_get"];

        $this->obj_tpl->tplDisplay("opt_dbconfig.tpl", $this->tplData);

        return array(
            "alert" => "y060306",
        );
    }


    function ctl_form() {
        $_act_get = fn_getSafe($GLOBALS["act_get"], "txt", "base");

        if (!isset($this->adminLogged["groupRow"]["group_allow"]["opt"][$_act_get])) {
            return array(
                "alert" => "x060301",
            );
        }

        if ($_act_get == "base") {
            $this->tplData["tplRows"]     = $this->obj_dir->list_dir(BG_PATH_TPL . "pub/");;
            $this->tplData["excerptType"] = $this->obj_tpl->type["excerpt"];;

            $_arr_timezoneRows  = include_once(BG_PATH_LANG . $this->config["lang"] . "/timezone.php");

            $_arr_timezone[] = "";

            if (stristr(BG_SITE_TIMEZONE, "/")) {
                $_arr_timezone = explode("/", BG_SITE_TIMEZONE);
            }

            $this->tplData["timezoneRows"]  = $_arr_timezoneRows;
            $this->tplData["timezoneJson"]  = json_encode($_arr_timezoneRows);
            $this->tplData["timezoneType"]  = $_arr_timezone[0];
        }

        $this->tplData["act_get"] = $_act_get;

        $this->obj_tpl->tplDisplay("opt_form.tpl", $this->tplData);

        return array(
            "alert" => "y060301",
        );
    }
}
