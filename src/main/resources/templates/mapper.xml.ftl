<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="${package.Mapper}.I${table.mapperName}">

<#if enableCache>
    <!-- 开启二级缓存 -->
    <cache type="org.mybatis.caches.ehcache.LoggingEhcache"/>

</#if>

<#if baseColumnList>
    <!-- 通用查询结果列 -->
    <sql id="Base_Column_List">
        <#list table.commonFields as field><#if field.propertyName!="tenantCode">`${field.name}`,</#if></#list>
        ${table.fieldNames}
    </sql>

</#if>


    <insert id="insert" parameterType="${entity}" useGeneratedKeys="true" keyProperty="id">

        INSERT INTO ${table.name} (
        <#list table.commonFields as field>
            <#if "id"!=field.name>
                <if test="${field.name}!=null">
                    `${field.name}`,
                </if>
            </#if>
        </#list>
        <#list table.fields as field>
            <#if "deleted"==field.name>
                `${field.name}`<#if field_has_next>,</#if>
            <#else>
                <if test="${field.name}!=null">
                    `${field.name}`<#if field_has_next>,</#if>
                </if>
            </#if>
        </#list>
        ) VALUES (
        <#list table.commonFields as field>
            <#if "id"!=field.name>
                <if test="${field.name}!=null">
                    ${r"#{"}${field.name}${r"}"},
                </if>
            </#if>
        </#list>
        <#list table.fields as field>
            <#if "deleted"==field.name>
                0<#if field_has_next>,</#if>
            <#else>
                <if test="${field.name}!=null">
                    ${r"#{"}${field.name}${r"}"}<#if field_has_next>,</#if>
                </if>
            </#if>

        </#list>
        )
            <selectKey keyProperty="id" order="AFTER" resultType="Long">
                SELECT LAST_INSERT_ID()
            </selectKey>
    </insert>

    <insert id="insertBatch" useGeneratedKeys="true" keyProperty="id">

        INSERT INTO ${table.name} (
        <#list table.commonFields as field>
            <#if "id"!=field.name>
                <if test="${field.name}!=null">
                    `${field.name}`,
                </if>
            </#if>
        </#list>
        <#list table.fields as field>
            <#if "deleted"==field.name>
                `${field.name}`<#if field_has_next>,</#if>
            <#else>
                <if test="${field.name}!=null">
                    `${field.name}`<#if field_has_next>,</#if>
                </if>
            </#if>
        </#list>
        ) VALUES
        <foreach collection="list" item="entity" separator=",">
            (
            <#list table.commonFields as field>
                <#if "id"!=field.name>
                    <if test="${field.name}!=null">
                        ${r"#{"}${field.name}${r"}"},
                    </if>
                </#if>
            </#list>
            <#list table.fields as field>
                <#if "deleted"==field.name>
                    0<#if field_has_next>,</#if>
                <#else>
                    <if test="${field.name}!=null">
                        ${r"#{"}${field.name}${r"}"}<#if field_has_next>,</#if>
                    </if>
                </#if>

            </#list>
            )
        </foreach>
    </insert>

    <insert id="insertMap" >
        INSERT INTO ${table.name} (
        <#list table.commonFields as field>
            <#if "id"!=field.name >
                <if test="${field.name}!=null">
                    `${field.name}`,
                </if>

            </#if>        </#list>
        <#list table.fields as field>
            <#if "deleted"==field.name>
                `${field.name}`<#if field_has_next>,</#if>
            <#else>
                <if test="${field.name}!=null">
                    `${field.name}`<#if field_has_next>,</#if>
                </if>
            </#if>

        </#list>
        ) VALUES (
        <#list table.commonFields as field>
            <#if "id"!=field.name>
                <if test="${field.name}!=null">
                    ${r"${map."}${field.name}${r"}"},
                </if>

            </#if>
        </#list>
        <#list table.fields as field>
            <#if "deleted"==field.name>
                0<#if field_has_next>,</#if>
            <#else >
                <if test="${field.name}!=null">
                    ${r"${map."}${field.name}${r"}"}<#if field_has_next>,</#if>
                </if>
            </#if>

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
                <#if "id"!=field.name>
                <if test="${field.name}!=null">
                    `${field.name}` = ${r"#{"}${field.name}${r"}"},
                </if>
                </#if>
            </#list>
            <#list table.fields as field>
                    <if test="${field.name}!=null">
                        `${field.name}` = ${r"#{"}${field.name}${r"}"},
                    </if>
            </#list>
        </trim>
        WHERE
        id = ${r"#{id}"} and `deleted`=0
    </update>

    <update id="updateMap">
        UPDATE ${table.name}
        <trim prefix="SET" suffixOverrides=",">
            <#list table.commonFields as field>
                <#if "id"!=field.name>
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
        id = ${r"${map.id"} and `deleted`=0
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
                <#if "deleted"!=field>
                    <if test="condition.${field.name}!=null">
                        AND `${field.name}` = ${r"#{condition."}${field.name}${r"}"}
                    </if>
                <#else >
                    and `deleted` = 0
                </#if>

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
                    `${field.name}` = ${r"#{"}${field.name}${r"}"},
                </#if>

            </#list>
            <#list table.fields as field>
                `${field.name}` = ${r"#{"}${field.name}${r"}"},
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
    <select id="findById" parameterType="Long" resultType="Role">
        SELECT
        <include refid="Base_Column_List"/>
        FROM ${table.name}
        <trim prefix="WHERE" prefixOverrides="AND | OR">
            AND id = ${r"#{id}"} and deleted = 0
        </trim>
    </select>

    <select id="findByIds" resultType="Role">
        SELECT
        <include refid="Base_Column_List"/>
        FROM ${table.name}
        <trim prefix="WHERE" prefixOverrides="AND | OR">
            id in
            <foreach item="id" collection="ids" separator="," open="(" close=")" index="">
                ${r"#{id}"}
            </foreach>
            and `deleted` = 0
        </trim>
    </select>


    <!-- 查询 -->
    <select id="queryList" resultType="${entity}">
        SELECT
            <include refid="Base_Column_List" />
        FROM ${table.name}
        <trim prefix="WHERE" prefixOverrides="AND | OR">
            <#list table.commonFields as field>
                <if test="condition.${field.name}!=null">
                    AND `${field.name}` = ${r"#{condition."}${field.name}${r"}"}
                </if>
            </#list>
            <#list table.fields as field>
                <if test="condition.${field.name}!=null">
                    AND `${field.name}` = ${r"#{condition."}${field.name}${r"}"}
                </if>
            </#list>
        </trim>
        order by `createTime` desc
    </select>



    <!-- 分页数据 start-->


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


    <delete id="deleteById" parameterType="Long">
        UPDATE ${table.name} set deleted = 1
        <trim prefix="WHERE" prefixOverrides="AND | OR">
            id =${r"#{id}"}
        </trim>
    </delete>

    <delete id="deleteByCondition" parameterType="java.util.Map">
        UPDATE ${table.name} set deleted = 1
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


    <delete id="deleteByIds" parameterType="Long">
        UPDATE ${table.name} set deleted = 1
        <trim prefix="WHERE" prefixOverrides="AND | OR">
            id in
            <foreach item="id" collection="ids" separator="," open="(" close=")" index="">
                ${r"#{id}"}
            </foreach>
        </trim>
    </delete>

</mapper>
