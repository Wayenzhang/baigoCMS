{* install_1.tpl 登录界面 *}
{$cfg = [
    sub_title  => $opt[$tplData.act_get].title,
    mod_help   => "install",
    act_help   => $tplData.act_get
]}
{include "{$smarty.const.BG_PATH_TPLSYS}install/default/include/install_head.tpl" cfg=$cfg}

    <form name="install_form" id="install_form">
        <input type="hidden" name="token_session" class="token_session" value="{$common.token_session}">
        <input type="hidden" name="act_post" value="{$tplData.act_get}">

        {if $tplData.act_get == "sso"}
            <p class="alert alert-warning">
                <span class="glyphicon glyphicon-exclamation-sign"></span>
                {$lang.text.installSso}
            </p>
            <p>
                <a href="{$smarty.const.BG_URL_INSTALL}ctl.php?mod=install&act_get=ssoAuto" class="btn btn-info">{$lang.href.ssoAuto}</a>
            </p>
        {/if}

        {foreach $opt[$tplData.act_get].list as $key=>$value}
            {if $smarty.const[$key]}
                {$this_value = $smarty.const[$key]}
            {else}
                {$this_value = $value.default}
            {/if}

            <div class="form-group">
                <div id="group_{$tplData.act_get}_{$key}">
                    <label class="control-label">{$value.label}<span id="msg_{$tplData.act_get}_{$key}">{if $value.min > 0}*{/if}</span></label>

                    {if $value.type == "select"}
                        <select name="opt[{$tplData.act_get}][{$key}]" id="opt_{$tplData.act_get}_{$key}" data-validate class="form-control input-lg">
                            {foreach $value.option as $key_opt=>$value_opt}
                                <option {if $this_value == $key_opt}selected{/if} value="{$key_opt}">{$value_opt}</option>
                            {/foreach}
                        </select>
                    {else if $value.type == "radio"}
                        {foreach $value.option as $key_opt=>$value_opt}
                            <div class="radio">
                                <label for="opt_{$tplData.act_get}_{$key}_{$key_opt}">
                                    <input type="radio" {if $this_value == $key_opt}checked{/if} value="{$key_opt}" data-validate="opt_{$tplData.act_get}_{$key}" name="opt[{$tplData.act_get}][{$key}]" id="opt_{$tplData.act_get}_{$key}_{$key_opt}">
                                    {$value_opt.value}
                                </label>
                            </div>
                            {if isset($value_opt.note)}<p class="help-block">{$value_opt.note}</p>{/if}
                        {/foreach}
                    {else if $value.type == "textarea"}
                        <textarea name="opt[{$tplData.act_get}][{$key}]" id="opt_{$tplData.act_get}_{$key}" data-validate class="form-control text_md">{$this_value}</textarea>
                    {else}
                        <input type="text" value="{$this_value}" name="opt[{$tplData.act_get}][{$key}]" id="opt_{$tplData.act_get}_{$key}" data-validate class="form-control input-lg">
                    {/if}

                    {if isset($value.note)}<p class="help-block">{$value.note}</p>{/if}
                </div>
            </div>
        {/foreach}

        {if $tplData.act_get == "base"}
            <div class="form-group">
                <label class="control-label">{$lang.label.tpl}<span id="msg_base_BG_SITE_TPL">*</span></label>
                <select name="opt[base][BG_SITE_TPL]" id="opt_base_BG_SITE_TPL" data-validate class="form-control input-lg">
                    {foreach $tplData.tplRows as $key=>$value}
                        {if $value["type"] == "dir"}
                            <option {if $smarty.const.BG_SITE_TPL == $value.name}selected{/if} value="{$value.name}">{$value.name}</option>
                        {/if}
                    {/foreach}
                </select>
            </div>

            <div class="form-group">
                <label class="control-label">{$lang.label.excerptDefault}<span id="msg_base_BG_SITE_EXCERPTTYPE">*</span></label>
                <select name="opt[base][BG_SITE_EXCERPTTYPE]" id="opt_base_BG_SITE_EXCERPTTYPE" data-validate class="form-control input-lg">
                    {foreach $tplData.excerptType as $key=>$value}
                        <option {if $smarty.const.BG_SITE_EXCERPTTYPE == $key}selected{/if} value="{$key}">{$value}</option>
                    {/foreach}
                </select>
            </div>
        {/if}

        <div class="form-group">
            <div class="btn-group">
                <button type="button" id="go_next" class="btn btn-primary btn-lg">{$lang.btn.save}</button>
                {include "{$smarty.const.BG_PATH_TPLSYS}install/default/include/install_drop.tpl" cfg=$cfg}
            </div>
        </div>
    </form>

{include "{$smarty.const.BG_PATH_TPLSYS}install/default/include/install_foot.tpl" cfg=$cfg}

    <script type="text/javascript">
    var opts_validator_form = {
        {foreach $opt[$tplData.act_get].list as $key=>$value}
            {if $value.type == "str" || $value.type == "textarea"}
                {$str_msg_min = "too_short"}
                {$str_msg_max = "too_long"}
            {else}
                {$str_msg_min = "too_few"}
                {$str_msg_max = "too_many"}
            {/if}
            opt_{$tplData.act_get}_{$key}: {
                len: { min: {$value.min}, max: 900 },
                validate: { selector: "[data-validate='opt_{$tplData.act_get}_{$key}']", type: "{$value.type}", {if isset($value.format)}format: "{$value.format}", {/if}group: "#group_{$tplData.act_get}_{$key}" },
                msg: { selector: "#msg_{$tplData.act_get}_{$key}", {$str_msg_min}: "{$alert.x060201}{$value.label}", {$str_msg_max}: "{$value.label}{$alert.x060202}", format_err: "{$value.label}{$alert.x060203}" }
            }{if !$value@last},{/if}
        {/foreach}
    };

    {if $tplData.act_get == "base"}
        opts_validator_form.opt_base_BG_SITE_TPL = {
            len: { min: 1, max: 900 },
            validate: { type: "select" },
            msg: { selector: "#msg_base_BG_SITE_TPL", too_few: "{$alert.x060201}{$lang.label.tpl}" }
        };

        opts_validator_form.opt_base_BG_SITE_EXCERPTTYPE = {
            len: { min: 1, max: 0 },
            validate: { type: "select" },
            msg: { selector: "#msg_base_BG_SITE_EXCERPTTYPE", too_few: "{$alert.x060201}{$lang.label.excerptDefault}" }
        };
    {/if}

    var opts_submit_form = {
        ajax_url: "{$smarty.const.BG_URL_INSTALL}ajax.php?mod=install",
        text_submitting: "{$lang.label.submitting}",
        btn_text: "{$lang.btn.stepNext}",
        btn_close: "{$lang.btn.close}",
        btn_url: "{$smarty.const.BG_URL_INSTALL}ctl.php?mod=install&act_get={$tplData.act_next}"
    };

    $(document).ready(function(){
        var obj_validator_form    = $("#install_form").baigoValidator(opts_validator_form);
        var obj_submit_form       = $("#install_form").baigoSubmit(opts_submit_form);
        $("#go_next").click(function(){
            if (obj_validator_form.verify()) {
                obj_submit_form.formSubmit();
            }
        });
    });
    </script>

{include "{$smarty.const.BG_PATH_TPLSYS}install/default/include/html_foot.tpl" cfg=$cfg}
