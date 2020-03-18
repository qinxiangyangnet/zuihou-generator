<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="${package.Mapper}.${table.mapperName}">

<#if enableCache>
    <!-- 开启二级缓存 -->
    <cache type="org.mybatis.caches.ehcache.LoggingEhcache"/>

</#if>
<#if baseResultMap>
    <!-- 通用查询映射结果 -->
    <resultMap id="BaseResultMap" type="${package.Entity}.${entity}">
<#list table.fields as field>
<#if field.keyFlag><#--生成主键排在第一位-->
    <#if field.type?starts_with("int")>
        <id column="${field.name}" jdbcType="INTEGER" property="${field.propertyName}"/>
    <#elseif field.type?starts_with("datetime")>
        <id column="${field.name}" jdbcType="TIMESTAMP" property="${field.propertyName}"/>
    <#elseif field.type?starts_with("text") || field.type?starts_with("longtext")>
        <id column="${field.name}" jdbcType="LONGVARCHAR" property="${field.propertyName}"/>
    <#else>
        <#if field.type?contains("(")>
        <#assign fType = field.type?substring(0, field.type?index_of("("))?upper_case/>
        <id column="${field.name}" jdbcType="${fType}" property="${field.propertyName}"/>
        <#else>
        <id column="${field.name}" jdbcType="${field.type?upper_case}" property="${field.propertyName}"/>
        </#if>
    </#if>
</#if>
</#list>
<#list table.commonFields as field><#--生成公共字段 -->
    <#if field.propertyName!="tenantCode">
    <#if field.keyFlag>
    <#if field.type?starts_with("int")>
        <id column="${field.name}" jdbcType="INTEGER" property="${field.propertyName}"/>
    <#elseif field.type?starts_with("datetime")>
        <id column="${field.name}" jdbcType="TIMESTAMP" property="${field.propertyName}"/>
    <#elseif field.type?starts_with("text") || field.type?starts_with("longtext")>
        <id column="${field.name}" jdbcType="LONGVARCHAR" property="${field.propertyName}"/>
    <#else>
        <#if field.type?contains("(")>
        <#assign fType = field.type?substring(0, field.type?index_of("("))?upper_case/>
        <id column="${field.name}" jdbcType="${fType}" property="${field.propertyName}"/>
        <#else>
        <id column="${field.name}" jdbcType="${field.type?upper_case}" property="${field.propertyName}"/>
        </#if>
    </#if>
    <#else>
    <#if field.type?starts_with("int")>
        <result column="${field.name}" jdbcType="INTEGER" property="${field.propertyName}"/>
    <#elseif field.type?starts_with("datetime")>
        <result column="${field.name}" jdbcType="TIMESTAMP" property="${field.propertyName}"/>
    <#elseif field.type?starts_with("text") || field.type?starts_with("longtext") || field.type?starts_with("mediumtext")>
        <result column="${field.name}" jdbcType="LONGVARCHAR" property="${field.propertyName}"/>
    <#else>
        <#if field.type?contains("(")>
        <#assign fType = field.type?substring(0, field.type?index_of("("))?upper_case/>
        <result column="${field.name}" jdbcType="${fType}" property="${field.propertyName}"/>
        <#else>
        <result column="${field.name}" jdbcType="${field.type?upper_case}" property="${field.propertyName}"/>
        </#if>
    </#if>
    </#if>
    </#if>
</#list>
<#list table.fields as field>
<#if !field.keyFlag><#--生成普通字段 -->

    <#assign myPropertyName="${field.propertyName}"/>
    <#-- 自动注入注解 -->
    <#if field.customMap.annotation?? && field.propertyName?ends_with("Id")>
        <#assign myPropertyName="${field.propertyName!?substring(0,field.propertyName?index_of('Id'))}"/>
    </#if>
    <#if field.type?starts_with("int")>
        <result column="${field.name}" jdbcType="INTEGER" property="${myPropertyName}"/>
    <#elseif field.type?starts_with("datetime")>
        <result column="${field.name}" jdbcType="TIMESTAMP" property="${myPropertyName}"/>
    <#elseif field.type?starts_with("text") || field.type?starts_with("longtext") || field.type?starts_with("mediumtext")>
        <result column="${field.name}" jdbcType="LONGVARCHAR" property="${myPropertyName}"/>
    <#else>
    <#if field.type?contains("(")>
        <#assign fType = field.type?substring(0, field.type?index_of("("))?upper_case/>
        <result column="${field.name}" jdbcType="${fType}" property="${myPropertyName}"/>
    <#else>
        <result column="${field.name}" jdbcType="${field.type?upper_case}" property="${myPropertyName}"/>
    </#if>
    </#if>
</#if>
</#list>
    </resultMap>

</#if>
<#if baseColumnList>
    <!-- 通用查询结果列 -->
    <sql id="Base_Column_List">
        <#list table.commonFields as field><#if field.propertyName!="tenantCode">`${field.name}`,</#if></#list>
        ${table.fieldNames}
    </sql>

</#if>

    <#if baseColumnList>
        <!-- 通用查询结果列 -->
        <sql id="Base_Insert_Column_List">
            <#list table.commonFields as field>
                <#if field.propertyName!="tenantCode">`${field.name}`,</#if>
            </#list>
            <#list table.commonFields as field>
                `${field.name}`<#if field_has_next>,</#if>
            </#list>
        </sql>
    </#if>

    <insert id="insert" parameterType="${entity}" useGeneratedKeys="true" keyProperty="id">

        INSERT INTO ${table.name} (
        <#list table.commonFields as field>
            <#if "id"!=field>
                `${field.name}`<#if field_has_next>,</#if>
            </#if>
        </#list>
        <#list table.fields as field>
            `${field.name}`<#if field_has_next>,</#if>
        </#list>
        ) VALUES (
        <#list table.commonFields as field>
            <#if "id"!=field>
                ${r"${"}${field.name}${r"}"}<#if field_has_next>,</#if>
            </#if>
        </#list>
        <#list table.fields as field>
                ${r"${"}${field.name}${r"}"}<#if field_has_next>,</#if>
        </#list>
        )
            <selectKey keyProperty="id" order="AFTER" resultType="Long">
                SELECT LAST_INSERT_ID()
            </selectKey>
    </insert>


    <insert id="insertMap" >
        INSERT INTO ${table.name} (
        <#list table.commonFields as field>
            <#if "id"!=field >
                `${field.name}`<#if field_has_next>,</#if>
            </#if>        </#list>
        <#list table.fields as field>
            `${field.name}`<#if field_has_next>,</#if>
        </#list>
        ) VALUES (
        <#list table.commonFields as field>
            <#if "id"!=field>
                ${r"${map."}${field.name}${r"}"}<#if field_has_next>,</#if>
            </#if>
        </#list>
        <#list table.fields as field>
            ${r"${map."}${field.name}${r"}"}<#if field_has_next>,</#if>
        </#list>
            <selectKey keyProperty="id" order="AFTER" resultType="Long">
                SELECT LAST_INSERT_ID()
            </selectKey>
        )
    </insert>


    <!-- 插入 end-->

    <!-- 修改 start-->
    <!-- 更新 -->
    <update id="update" parameterType="${entity}">
        UPDATE ${table.name}
        <trim prefix="SET" suffixOverrides=",">

            <#list table.commonFields as field>
                <#if "id"!=field>
                <if test="${field.name}!=null">
                    `${field.name}` = ${r"${"}${field.name}${r"}"},
                </if>
                </#if>
            </#list>
            <#list table.fields as field>
                    <if test="${field.name}!=null">
                        `${field.name}` = ${r"${"}${field.name}${r"}"},
                    </if>
            </#list>
        </trim>
        WHERE
        <#list table.commonFields as field>
        <if test="${field.name}!=null">
        `${field.name}` = ${r"${"}${field.name}${r"}"} <#if field_has_next> AND </#if>
        </if>
        </#list>
        <#list table.fields as field>
        <if test="${field.name}!=null">
        `${field.name}` = ${r"${"}${field.name}${r"}"} <#if field_has_next> AND </#if>
        </if>
        </#list>
    </update>

    <update id="updateMap">
        UPDATE ${table.name}
        <trim prefix="SET" suffixOverrides=",">
            <#list table.commonFields as field>
                <#if "id"!=field>
                    <if test="map.${field.name}!=null">
                        `${field.name}` = ${r"${map."}${field.name}${r"}"},
                    </if>
                </#if>
            </#list>
            <#list table.fields as field>
                <if test="map.${field.name}!=null">
                    `${field.name}` = ${r"${map."}${field.name}${r"}"},
                </if>
            </#list>
        </trim>
        WHERE
        id = ${r"${map.id"}
    </update>

    <update id="updateByCondition">
        UPDATE ${table.name}
        <trim prefix="SET" suffixOverrides=",">
            <#list table.commonFields as field>
               <#if "id"!=field>
                    <if test="update.${field.name}!=null">
                        `${field.name}` = ${r"${update."}${field.name}${r"}"},
                    </if>
               </#if>

            </#list>
            <#list table.fields as field>
                <if test="update.${field.name}!=null">
                    `${field.name}` = ${r"${update."}${field.name}${r"}"},
                </if>
            </#list>
        </trim>

        <trim prefix="WHERE" prefixOverrides="AND | OR">
            <#list table.commonFields as field>
                <if test="condition.${field.name}!=null">
                    `${field.name}` = ${r"#{condition."}${field.name}${r"}"}
                </if>
            </#list>
            <#list table.fields as field>
                <if test="condition.${field.name}!=null">
                    AND `${field.name}` = ${r"#{condition."}${field.name}${r"}"}
                </if>
            </#list>
        </trim>
    </update>

    <update id="updateByWhereSql">
        UPDATE ${table.name}
        <trim prefix="SET" suffixOverrides=",">
            <#list table.commonFields as field>
                <#if "id"!=field>
                    <if test="update.${field.name}!=null">
                        `${field.name}` = ${r"${update."}${field.name}${r"}"},
                    </if>
                </#if>

            </#list>
            <#list table.fields as field>
                <if test="update.${field.name}!=null">
                    `${field.name}` = ${r"${update."}${field.name}${r"}"},
                </if>
            </#list>
        </trim>


        <if test="nativeSql!=null">
            ${r"${nativeSql"}
        </if>
    </update>



    <update id="updateNull" parameterType="${entity}">
        UPDATE ${table.name}
        <trim prefix="SET" suffixOverrides=",">
            <#list table.commonFields as field>
                <#if "id"!=field>
                        `${field.name}` = ${r"${"}${field.name}${r"}"},
                </#if>

            </#list>
            <#list table.fields as field>
                    `${field.name}` = ${r"${"}${field.name}${r"}"},
            </#list>
        </trim>
        WHERE
     id = ${r"${id}"}
    </update>
    <!-- 修改 end-->

    <!-- 读取数据 start-->
    <select id="findOne" parameterType="Long" resultType="${entity}">
        SELECT
        <include refid="Base_Column_List" />
        FROM ${table.name}
        <trim prefix="WHERE" prefixOverrides="AND | OR">
                AND id = ${r"#{id}"}
        </trim>
    </select>

    <select id="findAll" resultType="${entity}">
        SELECT
        <include refid="Base_Column_List" />
        FROM ${table.name}
    </select>

    <!-- 查询 -->
    <select id="queryOne" resultType="${entity}">
        SELECT
            <include refid="Base_Column_List" />
        FROM ${table.name}
        <trim prefix="WHERE" prefixOverrides="AND | OR">
            <#list table.commonFields as field>
                <if test="condition.${field.name}!=null">
                    `${field.name}` = ${r"#{condition."}${field.name}${r"}"}
                </if>
            </#list>
            <#list table.fields as field>
                <if test="condition.${field.name}!=null">
                    AND `${field.name}` = ${r"#{condition."}${field.name}${r"}"}
                </if>
            </#list>
        </trim>
        LIMIT 0,1
    </select>

    <!-- 查询 -->
    <select id="queryOneByWhereSql" resultType="${entity}">
        SELECT
            <include refid="Base_Column_List" />
        FROM ${table.name}

        <if test="nativeSql!=null">
            ${r"${nativeSql}"}
        </if>
        LIMIT 0,1
    </select>

    <!-- 查询 -->
    <select id="queryList" resultType="${entity}">
        SELECT
            <include refid="Base_Column_List" />
        FROM ${table.name}
        <trim prefix="WHERE" prefixOverrides="AND | OR">
            <#list table.commonFields as field>
                <if test="condition.${field.name}!=null">
                    `${field.name}` = ${r"#{condition."}${field.name}${r"}"}
                </if>
            </#list>
            <#list table.fields as field>
                <if test="condition.${field.name}!=null">
                    AND `${field.name}` = ${r"#{condition."}${field.name}${r"}"}
                </if>
            </#list>
        </trim>
    </select>

    <!-- 查询 -->
    <select id="queryListByWhereSql" resultType="${entity}">
        SELECT
            <include refid="Base_Column_List" />
        FROM ${table.name}

        <if test="nativeSql!=null">
            ${r"${nativeSql}"}
        </if>
    </select>

    <select id="queryBySql" resultType="Map">
        ${r"${nativeSql}"}
    </select>

    <select id="queryBySqlCount" resultType="java.lang.Long">
        ${r"${executeSqlCount}"}
    </select>

    <!-- 读取数据 end-->

    <!-- 分页数据 start-->

    <select id="queryPage" resultType="${entity}">
        SELECT
            <include refid="Base_Column_List" />
        FROM ${table.name}
        <trim prefix="WHERE" prefixOverrides="AND | OR">
            <#list table.commonFields as field>
                <if test="condition.${field.name}!=null">
                    `${field.name}` = ${r"#{condition."}${field.name}${r"}"}
                </if>
            </#list>
            <#list table.fields as field>
                <if test="condition.${field.name}!=null">
                    AND `${field.name}` = ${r"#{condition."}${field.name}${r"}"}
                </if>
            </#list>
        </trim>

    </select>

    <select id="count" resultType="java.lang.Integer">
        SELECT count(1) FROM ${table.name}
        <trim prefix="WHERE" prefixOverrides="AND | OR">
            <#list table.commonFields as field>
                <if test="condition.${field.name}!=null">
                    `${field.name}` = ${r"#{condition."}${field.name}${r"}"}
                </if>
            </#list>
            <#list table.fields as field>
                <if test="condition.${field.name}!=null">
                    AND `${field.name}` = ${r"#{condition."}${field.name}${r"}"}
                </if>
            </#list>
        </trim>
    </select>

    <select id="countByWhereSql" resultType="java.lang.Integer">
        SELECT count(1) FROM ${table.name}
        <if test="nativeSql!=null">
            ${r"${nativeSql}"}
        </if>
    </select>

    <!-- 分页数据 end-->

    <!-- 删除 start-->
    <!-- 按Id删除 -->
    <delete id="delete" parameterType="Long">
        DELETE FROM ${table.name}
        <trim prefix="WHERE" prefixOverrides="AND | OR">
            id =${r"#{id} "}
        </trim>
    </delete>


    <delete id="deleteByCondition" parameterType="java.util.Map">
        DELETE FROM ${table.name}
        <trim prefix="WHERE" prefixOverrides="AND | OR">
            <#list table.commonFields as field>
                <if test="condition.${field.name}!=null">
                    `${field.name}` = ${r"#{condition."}${field.name}${r"}"}
                </if>
            </#list>
            <#list table.fields as field>
                <if test="condition.${field.name}!=null">
                    AND `${field.name}` = ${r"#{condition."}${field.name}${r"}"}
                </if>
            </#list>
        </trim>
    </delete>

    <delete id="deleteByWhereSql" parameterType="java.lang.String">
        DELETE FROM ${table.name}
        <if test="nativeSql!=null">
            ${r"${nativeSql}"}
        </if>
        <if test="nativeSql==null">
            WHERE 1=2
        </if>
    </delete>

    <delete id="deleteAll" >
        DELETE FROM ${table.name}
    </delete>
</mapper>
