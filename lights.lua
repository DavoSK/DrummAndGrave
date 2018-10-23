Lights = {}
Lights.shaderCode = [[
	#define NUM_LIGHTS 256
	struct Light {
		vec2 position;
		vec3 diffuse;
		float power;
	};

	extern Light lights[NUM_LIGHTS];
	extern int num_lights;
	extern vec2 screen;
	const float constant = 1.0;
	const float linear = 0.09;
	const float quadratic = 0.032;
	vec4 effect(vec4 color, Image image, vec2 uvs, vec2 screen_coords){
		vec4 pixel = Texel(image, uvs);
		vec2 norm_screen = screen_coords / screen;
		vec3 diffuse = vec3(0);
		for (int i = 0; i < num_lights; i++) {
			Light light = lights[i];
			vec2 norm_pos = light.position / screen;
			
			float distance = length(norm_pos - norm_screen) * light.power;
			float attenuation = 1.0 / (constant + linear * distance + quadratic * (distance * distance));
			diffuse += light.diffuse * attenuation;
		}
		diffuse = clamp(diffuse, 0.0, 1.0);
		return pixel * vec4(diffuse, 1.0);
	}
]]

Lights.shader = nil
Lights.lights = {}

function Lights:Init()
    self.shader = love.graphics.newShader(self.shaderCode)
end

function Lights:Add(pos, diffuse, power) 
	local newLight = {}
	newLight.position = pos
	newLight.diffuse = diffuse
	newLight.power = power
	table.insert(self.lights, newLight)
end

function Lights:Draw(cam)
    love.graphics.setShader(self.shader)

    self.shader:send("screen", {
        love.graphics.getWidth(),
        love.graphics.getHeight()
    })

	self.shader:send("num_lights", #self.lights)
	
    for i = 0, #self.lights - 1 do
		local name = "lights[" .. i .."]"
		local lightData = self.lights[ i + 1]
		screenX, screenY = cam:getScreenCoordinates(lightData.position.x, lightData.position.y)
    	self.shader:send(name .. ".position", {screenX, screenY})
		self.shader:send(name .. ".diffuse", {lightData.diffuse.r, lightData.diffuse.g, lightData.diffuse.b})
		self.shader:send(name .. ".power", lightData.power)
	end
end

return Lights