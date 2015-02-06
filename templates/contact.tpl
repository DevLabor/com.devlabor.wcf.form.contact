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

{if CONTACT_ADDRESS != '' || CONTACT_PHONE != '' || CONTACT_FAX != '' || CONTACT_MAIL != ''}
<div class="container containerPadding marginTop">
	<fieldset>
		<legend>{lang}wcf.contact.address{/lang}</legend>

		<dl>
            {if CONTACT_ADDRESS != ''}
			<dt>{lang}wcf.contact.address{/lang}</dt>
			<dd>
				<address>{@CONTACT_ADDRESS|nl2br}</address>
			</dd>
            {/if}

            {if CONTACT_PHONE != ''}
			<dt>{lang}wcf.contact.phone{/lang}</dt>
			<dd>{@CONTACT_PHONE}</dd>
            {/if}

            {if CONTACT_FAX != ''}
			<dt>{lang}wcf.contact.fax{/lang}</dt>
			<dd>{@CONTACT_FAX}</dd>
            {/if}

            {if CONTACT_MAIL != ''}
			<dt>{lang}wcf.contact.mail{/lang}</dt>
			<dd>{@CONTACT_MAIL}</dd>
            {/if}
		</dl>
	</fieldset>
</div>
{/if}

<form method="post" action="{link controller='Contact'}{/link}">
    <div class="container containerPadding marginTop">
        <fieldset>
            <legend>{lang}wcf.contact.message{/lang}</legend>

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

			{if CONTACT_MAIL_CATEGORIES && $availableCategories|count > 0}
				<dl{if $errorField == 'categoryMail'} class="formError"{/if}>
					<dt><label for="categoryMail">{lang}wcf.contact.categoryMail{/lang}</label></dt>
					<dd>
						<select name="categoryMail" id="categoryMail">
							{foreach from=$availableCategories key=__mail item=__category}
								<option value="{$__mail}"{if $categoryMail == $__mail} selected="selected"{/if}>{lang}{$__category}{/lang}</option>
							{/foreach}
						</select>
						{if $errorField == 'categoryMail'}
							<small class="innerError">
								{if $errorType == 'empty'}
									{lang}wcf.global.form.error.empty{/lang}
								{else}
									{lang}wcf.contact.categoryMail.error.{$errorType}{/lang}
								{/if}
							</small>
						{/if}
					</dd>
				</dl>
			{/if}

            {event name='informationFields'}

            <dl class="{if $errorField == 'message'} formError{/if}">
				<dt><label for="message">{lang}wcf.contact.message{/lang}</label></dt>
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
