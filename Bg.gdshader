shader_type spatial;

uniform sampler2D tex;

void fragment() {
	
	if(texture(tex,UV).r < 0.5){
		ALBEDO = texture(tex,UV).rgb*0.2;
	}else{
		ALBEDO = texture(tex,UV).rgb;
	}
	ALPHA = 1.;
	METALLIC = 0.;
	SPECULAR = 0.;
}
