<?php
/*-----------------------------------------------------------------
！！！！警告！！！！
以下为系统文件，请勿修改
-----------------------------------------------------------------*/

//不能非法包含或直接执行
if(!defined("IN_BAIGO")) {
    exit("Access Denied");
}

include_once(BG_PATH_FUNC . "init.func.php");
$arr_set = array(
    "base"          => true,
    "ssin"          => true,
    "header"        => "Content-Type: text/html; charset=utf-8",
    "db"            => true,
    "type"          => "ctl",
    "ssin_begin"    => true,
);
fn_init($arr_set);

include_once(BG_PATH_INC . "is_install.inc.php"); //验证是否已登录
include_once(BG_PATH_INC . "is_admin.inc.php"); //验证是否已登录
include_once(BG_PATH_CONTROL . "admin/ctl/app.class.php"); //载入应用控制器

$ctl_app = new CONTROL_APP(); //初始化应用

switch ($GLOBALS["act_get"]) {
    case "show": //显示
        $arr_appRow = $ctl_app->ctl_show();
        if ($arr_appRow["alert"] != "y190102") {
            header("Location: " . BG_URL_ADMIN . "ctl.php?mod=alert&act_get=show&alert=" . $arr_appRow["alert"]);
            exit;
        }
    break;

    case "form": //创建、编辑表单
        $arr_appRow = $ctl_app->ctl_form();
        if ($arr_appRow["alert"] != "y190102") {
            header("Location: " . BG_URL_ADMIN . "ctl.php?mod=alert&act_get=show&alert=" . $arr_appRow["alert"]);
            exit;
        }
    break;

    case "belong": //用户授权
        $arr_appRow = $ctl_app->ctl_belong();
        if ($arr_appRow["alert"] != "y190302") {
            header("Location: " . BG_URL_ADMIN . "ctl.php?mod=alert&act_get=show&alert=" . $arr_appRow["alert"]);
            exit;
        }
    break;

    default: //列出
        $arr_appRow = $ctl_app->ctl_list();
        if ($arr_appRow["alert"] != "y190302") {
            header("Location: " . BG_URL_ADMIN . "ctl.php?mod=alert&act_get=show&alert=" . $arr_appRow["alert"]);
            exit;
        }
    break;
}
