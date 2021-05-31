require("BoxLib");
-- 屏幕常量
device.keepWake();
currentIndex = 1;

-- 查找广告按钮并点击
function findAdButtonAndClick()
    local wid= widget.desc("观看创意广告");
    if wid ~= nil then
        mSleep(1000)
        toast("控件已找到")
        mSleep(1000)
        --点击控件
        widget.click(wid)
        mSleep(1000)
        --点击控件
        widget.click(wid)
        mSleep(3000)
        return true;
    else
        mSleep(1000)
        mSleep(1000)
        return false;
    end
end

-- 返回app
function backApp()
    mSleep(getRndNum(3000,5000));
    local flag = app.runApp("com.yk.sports");
    if  flag == true then
        mSleep(5000);
        -- 查找关闭按钮并点击
        findCloseButtonAndClick();
    end
end

-- 点击
function tapAction()
    local num = getRndNum(1,5);
    if num == 3 then
        findOpenButtonAndClick()
    else 
        findCloseButtonAndClick()
    end
end

-- 查找打开按钮并点击
function findOpenButtonAndClick()
    toast("点击广告")
    local w,h = getScreenSize();
    event.tap(w / 2, h / 2);
    mSleep(3000);
    -- 检测应用是否打开
    local packageName = app.frontPackageName();
    local currentPackageName = currentPackage()
    if packageName ~= currentPackageName then
        app.runApp(currentPackageName);
        mSleep(3000);
    end
    findCloseButtonAndClick()
end

-- 查找关闭按钮并点击
function findCloseButtonAndClick()
    toast("查找关闭按钮")
    local result = false;
    local titles = {"关闭", "關閉", "Close", "返回", "back"};
    for i = 1, #titles do
        local title = titles[i];
        local wid= widget.text(title);
        if wid ~= nil then
            mSleep(1000)
            toast(title.."控件已找到"); 
            mSleep(1000)
            --点击控件
            widget.click(wid)
            mSleep(1000);
            widget.click(wid)
            mSleep(1000);
            result = true;
            break;
        end
    end

    wid= widget.id("close-button-icon");
    if wid ~= nil then
        mSleep(1000)
        toast("close-button-icon"); 
        mSleep(1000)
        --点击控件
        widget.click(wid)
        mSleep(1000)
        result = true;
    end

    if result == false then
        keycode.back();
        mSleep(3000)
        local page = getCurrentPage();
        if page ~= "运动" then
            local w,h = getScreenSize();
            event.tap(w - 70, 160);
        end
    end
end

function getCurrentPage()
    local wid= widget.desc("运动");
    if wid ~= nil then
        return "运动";
    end
    return nil;
end

function currentPackage()
    local apps = {"com.yk.sports", "com.yk.health", "com.yk.sports.vungle"};
    local name = apps[currentIndex];
    if name == nil then
        currentIndex = 1;
        name = apps[currentIndex];
    end
    return name;
end



for i=1,9999 do
    -- 检测应用是否打开
    packageName = app.frontPackageName();
    local currentPackageName = currentPackage()
    if packageName ~= currentPackageName then
        app.runApp(currentPackageName);
        mSleep(3000);
    end

    page = getCurrentPage();
    if page == "运动" then
        -- 查找广告按钮并点击
        result = findAdButtonAndClick();
        if result == true then
            page = getCurrentPage();
            if page ~= "运动" then
                mSleep(getRndNum(25000, 30000));
                tapAction();
                mSleep(3000);
            end
            currentIndex = currentIndex + 1;
        else
            currentIndex = currentIndex + 1;
        end
    else
        toast("未知页面，返回"); 
        keycode.back();
        mSleep(2000)
    end
end
