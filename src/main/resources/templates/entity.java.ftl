package ${package.Entity};

import java.io.Serializable;

<#if swagger2>
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
</#if>
import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;
import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.Range;
import java.time.LocalDateTime;
<#if entityLombokModel>
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import lombok.ToString;
import lombok.experimental.Accessors;
</#if>
<#if cfg.filedTypes??>
<#list cfg.filedTypes as fieldType>
    <#list table.fields as field>
        <#if field.propertyName == fieldType.name && table.name==fieldType.table && field.propertyType=="String">
import ${fieldType.packagePath};
            <#break>
        </#if>
    </#list>
</#list>
</#if>

<#assign tableComment = "${table.comment!''}"/>
<#if table.comment?? && table.comment!?contains('\n')>
    <#assign tableComment = "${table.comment!?substring(0,table.comment?index_of('\n'))?trim}"/>
</#if>
/**
 * <p>
 * 实体类
 * ${table.comment!?replace("\n","\n * ")}
 * </p>
 *
 * @author ${author}
 * @since ${date}
 */
<#if entityLombokModel>
@Data
@NoArgsConstructor
@ToString(callSuper = true)
@Accessors(chain = true)
</#if>
<#if swagger2>
@ApiModel(value = "${entity}", description = "${tableComment}")
</#if>
<#if superEntityClass??>
@AllArgsConstructor
<#assign hasCustomAnno="0"/>
<#if superEntityClass?? && superEntityClass=="TreeEntity">
    <#assign hasCustomAnno="1"/>
</#if>
public class ${entity} implements Serializable {
</#if>

    private static final long serialVersionUID = 1L;

<#setting number_format="0">
<#-- ----------  BEGIN 字段循环遍历  ---------->
<#list table.commonFields as field>
<#-- 如果有父类，排除公共字段 -->
    <#if (superEntityClass?? && cfg.superExtend?? && field.propertyName !="id") || (superEntityClass?? && field.propertyName !="id" && field.propertyName !="createTime" && field.propertyName != "updateTime" && field.propertyName !="createUser" && field.propertyName !="updateUser") || !superEntityClass??>
        <#if field.keyFlag>
            <#assign keyPropertyName="${field.propertyName}"/>
        </#if>
        <#assign fieldComment="${field.comment!}"/>
        <#if field.comment!?length gt 0>
            /**
            * ${field.comment!?replace("\n","\n     * ")}
            */
            <#if field.comment!?contains("\n") >
                <#assign fieldComment="${field.comment!?substring(0,field.comment?index_of('\n'))?replace('\r\n','')?replace('\r','')?replace('\n','')?trim}"/>
            </#if>
        </#if>
        <#assign myPropertyType="${field.propertyType}"/>
        <#assign isEnumType="1"/>
        <#list cfg.filedTypes as fieldType>
            <#if fieldType.name == field.propertyName && table.name==fieldType.table && field.propertyType=="String">
                <#assign myPropertyType="${fieldType.type}"/>
                <#assign isEnumType="2"/>
            </#if>
        </#list>

        <#if field.keyFlag>

        <#-- 普通字段 -->
        <#elseif field.fill??>
        <#elseif field.convert>
        </#if>
        <#assign myPropertyName="${field.propertyName}"/>

        private ${myPropertyType} ${myPropertyName};
    </#if>

</#list>
<#list table.fields as field>
    <#-- 如果有父类，排除公共字段 -->
    <#if (superEntityClass?? && cfg.superExtend?? && field.propertyName !="id") || (superEntityClass?? && field.propertyName !="id" && field.propertyName !="createTime" && field.propertyName != "updateTime" && field.propertyName !="createUser" && field.propertyName !="updateUser") || !superEntityClass??>
    <#if field.keyFlag>
        <#assign keyPropertyName="${field.propertyName}"/>
    </#if>
    <#assign fieldComment="${field.comment!}"/>
    <#if field.comment!?length gt 0>
    /**
     * ${field.comment!?replace("\n","\n     * ")}
     */
    <#if field.comment!?contains("\n") >
        <#assign fieldComment="${field.comment!?substring(0,field.comment?index_of('\n'))?replace('\r\n','')?replace('\r','')?replace('\n','')?trim}"/>
    </#if>
    </#if>
    <#if swagger2>
    @ApiModelProperty(value = "${fieldComment}")
    </#if>
    <#assign myPropertyType="${field.propertyType}"/>
    <#assign isEnumType="1"/>
    <#list cfg.filedTypes as fieldType>
        <#if fieldType.name == field.propertyName && table.name==fieldType.table && field.propertyType=="String">
            <#assign myPropertyType="${fieldType.type}"/>
            <#assign isEnumType="2"/>
        </#if>
    </#list>
    <#if field.customMap.Null == "NO" >
        <#if (field.columnType!"") == "STRING" && isEnumType == "1">
    @NotEmpty(message = "${fieldComment}不能为空")
        <#else>
    @NotNull(message = "${fieldComment}不能为空")
        </#if>
    </#if>
    <#if (field.columnType!"") == "STRING" && isEnumType == "1">
        <#assign max = 255/>
        <#if field.type?starts_with("varchar") || field.type?starts_with("char")>
            <#if field.type?contains("(")>
                <#assign max = field.type?substring(field.type?index_of("(") + 1, field.type?index_of(")"))/>
            </#if>
    @Length(max = ${max}, message = "${fieldComment}长度不能超过${max}")
        <#elseif field.type?starts_with("text")>
        <#assign max = 65535/>
    @Length(max = ${max}, message = "${fieldComment}长度不能超过${max}")
        <#elseif field.type?starts_with("mediumtext")>
        <#assign max = 16777215/>
    @Length(max = ${max}, message = "${fieldComment}长度不能超过${max}")
        <#elseif field.type?starts_with("longtext")>

        </#if>
    <#else>
        <#if field.propertyType?starts_with("Short")>
    @Range(min = Short.MIN_VALUE, max = Short.MAX_VALUE, message = "${fieldComment}长度不能超过"+Short.MAX_VALUE)
        </#if>
        <#if field.propertyType?starts_with("Byte")>
    @Range(min = Byte.MIN_VALUE, max = Byte.MAX_VALUE, message = "${fieldComment}长度不能超过"+Byte.MAX_VALUE)
        </#if>
        <#if field.propertyType?starts_with("Short")>
    @Range(min = Short.MIN_VALUE, max = Short.MAX_VALUE, message = "${fieldComment}长度不能超过"+Short.MAX_VALUE)
        </#if>
    </#if>
    <#if field.keyFlag>

    <#-- 普通字段 -->
    <#elseif field.fill??>
    <#elseif field.convert>
    </#if>
    <#assign myPropertyName="${field.propertyName}"/>

        private ${myPropertyType} ${myPropertyName};
    </#if>

</#list>

<#------------  END 字段循环遍历  ---------->
<#if !entityLombokModel>

    <#list table.fields as field>
        <#if field.propertyType == "boolean">
            <#assign getprefix="is"/>
        <#else>
            <#assign getprefix="get"/>
        </#if>
    public ${field.propertyType} ${getprefix}${field.capitalName}() {
        return ${field.propertyName};
    }

        <#if entityBuilderModel>
    public ${entity} set${field.capitalName}(${field.propertyType} ${field.propertyName}) {
        <#else>
    public void set${field.capitalName}(${field.propertyType} ${field.propertyName}) {
        </#if>
        this.${field.propertyName} = ${field.propertyName};
        <#if entityBuilderModel>
        return this;
        </#if>
    }
    </#list>
</#if>

<#-- 如果有父类，自定义无全参构造方法 -->

}
<#if activeRecord>

    @Override
    protected Serializable pkVal() {
    <#if keyPropertyName??>
        return this.${keyPropertyName};
    <#else>
        return null;
    </#if>
    }
</#if>
<#if !entityLombokModel>

    @Override
    public String toString() {
        return "${entity}{" +
    <#list table.fields as field>
        <#if field_index==0>
        "${field.propertyName}=" + ${field.propertyName} +
        <#else>
        ", ${field.propertyName}=" + ${field.propertyName} +
        </#if>
    </#list>
        "}";
    }
</#if>

