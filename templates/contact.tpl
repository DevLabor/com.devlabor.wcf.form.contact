{include file='documentHeader'}

<head>
    <title>{lang}wcf.contact.title{/lang} - {PAGE_TITLE|language}</title>

    {include file='headInclude'}
</head>

<body id="tpl{$templateName|ucfirst}">
{include file='header'}

<header class="boxHeadline">
    <h1>{lang}wcf.contact.title{/lang}</h1>
</header>

{include file='userNotice'}

{include file='formError'}

<div class="contentNavigation">
    {hascontent}
        <nav>
            <ul>
                {content}
                	{event name='contentNavigationButtons'}
                {/content}
            </ul>
        </nav>
    {/hascontent}
</div>

<form method="post" action="{link controller='Contact'}{/link}">
    <div class="container containerPadding marginTop">
        <fieldset>
            <legend>{lang}wcf.contact.general{/lang}</legend>

            <dl{if $errorField == 'subject'} class="formError"{/if}>
                <dt><label for="subject">{lang}wcf.contact.subject{/lang}</label></dt>
                <dd>
                    <input type="text" id="subject" name="subject" value="{$subject}" required="required" class="long" />
                    {if $errorField == 'subject'}
                        <small class="innerError">
                            {if $errorType == 'empty'}
                                {lang}wcf.global.form.error.empty{/lang}
                            {else}
                                {lang}wcf.contact.subject.error.{@$errorType}{/lang}
                            {/if}
                        </small>
                    {/if}
                </dd>
            </dl>

            {if !$__wcf->user->userID}
                <dl{if $errorField == 'email'} class="formError"{/if}>
                    <dt><label for="email">{lang}wcf.contact.senderEmail{/lang}</label></dt>
                    <dd>
                        <input type="email" id="email" name="email" value="{$email}" required="required" class="long" />
						<small>{lang}wcf.contact.senderEmail.description{/lang}</small>
                        {if $errorField == 'email'}
                            <small class="innerError">
                                {if $errorType == 'empty'}
                                    {lang}wcf.global.form.error.empty{/lang}
                                {elseif $errorType == 'invalid'}
                                    {lang}wcf.user.email.error.notValid{/lang}
                                {else}
                                    {lang}wcf.contact.senderEmail.error.{@$errorType}{/lang}
                                {/if}
                            </small>
                        {/if}
                    </dd>
                </dl>
            {/if}

            {event name='informationFields'}
        </fieldset>

        <fieldset>
            <legend><label for="message">{lang}wcf.contact.message{/lang}</label></legend>

            <dl class="wide{if $errorField == 'message'} formError{/if}">
                <dd>
                    <textarea rows="15" cols="40" name="message" id="message" required="required">{$message}</textarea>
                    {if $errorField == 'message'}
                        <small class="innerError">
                            {if $errorType == 'empty'}
                                {lang}wcf.global.form.error.empty{/lang}
                            {else}
                                {lang}wcf.contact.message.error.{@$errorType}{/lang}
                            {/if}
                        </small>
                    {/if}
                </dd>
            </dl>

            {event name='messageFields'}
        </fieldset>

        {event name='fieldsets'}

        {if $useCaptcha}
            {include file='recaptcha'}
        {/if}
    </div>

    <div class="formSubmit">
        <input type="submit" value="{lang}wcf.global.button.submit{/lang}" accesskey="s" />
		{@SECURITY_TOKEN_INPUT_TAG}
    </div>
</form>

{include file='footer'}

</body>
</html>
